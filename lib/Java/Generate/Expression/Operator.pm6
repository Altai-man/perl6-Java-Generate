unit module Java::Generate::Expression::Operator;

use Java::Generate::Expression;
use Java::Generate::Literal;
use Java::Generate::Variable;

my subset Operand where Variable|Literal|Expression;

class PrefixOp does Expression is export {
    my subset Op of Str where '++'|'--'|'+'|'-'|'~'|'!';
    has Operand $.right;
    has Op $.op;

    method generate() {
        my $right = $_ ~~ Variable ?? .reference() !! .generate() given $!right;
        $right = "($right)" if $!right ~~ Expression;
        "{$!op}$right"
    }
}

class PostfixOp does Expression is export {
    my subset Op of Str where '++'|'--';
    has Operand $.left;
    has Op $.op;

    method generate() {
        my $left = $_ ~~ Variable ?? .reference() !! .generate() given $!left;
        $left = "($left)" if $!left ~~ Expression;
        "{$left}{$!op}"
    }
}

class Assignment does Expression is export {
    has Variable $.left;
    has Operand $.right;

    method generate(--> Str) {
        my $right = $_ ~~ Variable ?? .reference() !! .generate() given $!right;
        "{$!left.reference()} = $right"
    }
}

class InfixOp does Expression is export {
    my subset Op of Str where '+'|'-'|'*'|'/'|'%'|
                              '<<'|'>>'|'>>>'|
                              '&'|'^'|'|'|
                              '<'|'>'|'=='|'!='||'&&'|'||';

    has Operand $.left;
    has Operand $.right;
    has Op $.op;

    method generate(--> Str) {
        my $left  = $_ ~~ Variable ?? .reference() !! .generate() given $!left;
        my $right = $_ ~~ Variable ?? .reference() !! .generate() given $!right;
        $left  = "($left)"  if $!left  ~~ Expression;
        $right = "($right)" if $!right ~~ Expression;
        "$left {$!op} $right"
    }
}

class Ternary does Expression is export {
    has InfixOp $.cond;
    has Operand $.true;
    has Operand $.false;

    method generate(--> Str) {
        unless $!cond.op eq '<'|'>'|'=='|'!='|'&&'|'||' {
            die "Ternary operator condition expression is not boolean, it\'s operator is {$!cond.op}";
        }

        my $true  = $_ ~~ Variable ?? .reference() !! .generate() given $!true;
        my $false = $_ ~~ Variable ?? .reference() !! .generate() given $!false;
        "{$!cond.generate} ? $true : $false"
    }
}
