use Java::Generate::ASTNode;
use Java::Generate::Argument;
use Java::Generate::Utils;

unit module Java::Generate::Statement;

role Statement does ASTNode is export {}

role Expression does Statement is export {
    method operands() {()}
}

role Variable does Expression does Argument is export {
    has Expression $.default;
    has $.initialized is rw = True;
    has $.name;
    has $.type;
    has Modifier @.modifiers;

    method reference(--> Str) { "{$!name}" }
}

role Literal does Expression is export {}

class LocalVariable does Variable is export {
    submethod TWEAK() { $!initialized = False unless $!default }

    method generate() {
        my $code = @!modifiers.join(', ') ~ ' ' if @!modifiers;
        $code ~= "{$!type} {$!name}";
        $code ~= $!default ?? " = {$!default.generate};" !! ";"
    }
}

class VariableDeclaration does Statement is export {
    has LocalVariable $.variable;

    multi method new($variable) {
        self.bless(:$variable)
    }
    multi method new($name, $type, @modifiers) {
        self.bless(variable => LocalVariable.new(:$name, :$type, :@modifiers));
    }
    multi method new($name, $type, @modifiers, $default) {
        self.bless(variable => LocalVariable.new(:$name, :$type, :@modifiers, :$default));
    }

    method generate(--> Str) {
        $!variable.generate();
    }
}

class Return does Statement is export {
    has Expression $.return;

    method generate(--> Str) {
        "return {$!return.generate};"
    }
}

role Flow does Statement is export {
    has Int $.indent = 4;
}

class If does Flow is export {
    has Expression $.cond;
    has Statement @.true;
    has Statement @.false;

    method generate(--> Str) {
        my $code = "if ({$!cond.generate}) \{\n{@!true.map(*.generate).join(";\n").indent($!indent)}\n\}";
        if @!false {
            $code ~= " else \{\n{@!false.map(*.generate).join(";\n").indent($!indent)}\n\}"
        }
        $code;
    }
}

class While does Flow is export {
    has Expression $.cond;
    has Statement @.body;
    has Bool $.after;

    method generate(--> Str) {
        my $condition = "while ({$!cond.generate})";
        my $statements = " \{\n{@!body.map(*.generate).join(";\n").indent($!indent)}\n\}";
        if $!after {
            return "do$statements $condition;";
        } else {
            return "{$condition}{$statements}";
        }
    }
}

class Switch does Flow is export {
    has Variable $.switch;
    has Pair @.branches;

    method generate(--> Str) {
        my $code = "switch ({$!switch.reference}) \{\n";
        for @!branches {
            $code ~= "case {$_.key.generate}:\n";
            $code ~= (.value.map(*.generate).join(";\n") ~ ';').indent($!indent) ~ "\nbreak;\n".indent($!indent);
        }
        $code ~ '}';
    }
}

class For does Flow is export {
    has Statement $.initializer;
    has Expression $.cond;
    has Statement $.increment;
    has Statement @.body;

    method generate(--> Str) {
        my $initializer = $!initializer.generate() ~ ($!initializer ~~ VariableDeclaration ?? '' !! ';');
        my $code = "for ({$initializer} {$!cond.generate}; {$!increment.generate}) \{\n";
        for @!body {
            $code ~= (.generate ~ "\n").indent($!indent)
        }
        $code ~= '}';
    }
}

class Continue does Flow is export {
    method generate(--> Str) { 'continue;' }
}

class Break does Flow is export {
    method generate(--> Str) { 'break;' }
}

# class Try does Statement is export {}

# class Throw does Statement is export {}
