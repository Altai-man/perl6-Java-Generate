unit module Java::Generate::Expression::Operator;

use Java::Generate::Expression;
use Java::Generate::Literal;
use Java::Generate::Variable;

my subset Operand where Variable|Literal|Expression;

class PrefixOp does Expression {
    method generate() {...}
}

class PostfixOp does Expression {
    method generate() {...}
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
        my $true  = $_ ~~ Variable ?? .reference() !! .generate() given $!true;
        my $false = $_ ~~ Variable ?? .reference() !! .generate() given $!false;
        "{$!cond.generate} ? $true : $false"
    }
}
