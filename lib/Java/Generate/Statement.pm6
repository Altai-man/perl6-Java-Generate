use Java::Generate::ASTNode;
use Java::Generate::Argument;
use Java::Generate::JavaParameter;
use Java::Generate::Utils;

unit module Java::Generate::Statement;

role Statement does ASTNode is export {}

role Expression does Statement does Argument is export {
    method operands() {()}
    method reference() {self.generate}
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
        "return {$_ ~~ Variable ?? .reference !! .generate given $!return}"
    }
}

role Flow does Statement is export {
    has Int $.indent = 4;
}

role SelfTerminating does Flow is export {};

class If does SelfTerminating is export {
    has Expression $.cond;
    has Statement @.true;
    has Statement @.false;

    method generate(--> Str) {
        my $true = @!true.map(*.generate).join(";\n").indent($!indent);
        my $code = "if ({$!cond.generate}) \{\n$true;\n\}";
        if @!false {
            my $false = @!false.map(*.generate).join(";\n").indent($!indent);
            $code ~= " else \{\n$false;\n\}"
        }
        $code;
    }
}

class While does SelfTerminating is export {
    has Expression $.cond;
    has Statement @.body;
    has Bool $.after;

    method generate(--> Str) {
        my $condition = "while ({$!cond.generate})";
        my $block = @!body.map(*.generate).join(";\n").indent($!indent) ~ ';';
        my $statements = " \{\n$block\n\}";
        $!after ?? "do$statements $condition;" !! "{$condition}{$statements}";
    }
}

class Throw does Flow is export {
    has Str $.exception;

    method generate(--> Str) {
        "throw new {$!exception}()";
    }
}

class Switch does SelfTerminating is export {
    has Variable $.switch;
    has Pair @.branches;
    has Statement @.default;

    method generate(--> Str) {
        my $code = "switch ({$!switch.reference}) \{\n";
        for @!branches {
            $code ~= "case {$_.key.generate}:\n";
            $code ~= self!do-branch(.value) if .value;
        }
        with @!default {
            if @!default {
                $code ~= "default:\n";
                $code ~= self!do-branch($_);
            }
        }
        $code ~ '}';
    }

    method !do-branch($_) {
        my $line = (.map(*.generate).join(";\n") ~ ';').indent($!indent);
        $line ~= "\nbreak;".indent($!indent) unless $_[*-1] ~~ Return|Throw;
        "$line\n";
    }
}

class For does SelfTerminating is export {
    has Statement $.initializer;
    has Expression $.cond;
    has Statement $.increment;
    has Statement @.body;

    method generate(--> Str) {
        my $initializer = $!initializer.generate() ~ ($!initializer ~~ VariableDeclaration ?? '' !! ';');
        my $block = .generate.join(";\n").indent($!indent) for @!body;
        my $code = "for ({$initializer} {$!cond.generate}; {$!increment.generate}) \{\n$block;\n\}";
    }
}

class Continue does Flow is export {
    method generate(--> Str) { 'continue' }
}

class Break does Flow is export {
    method generate(--> Str) { 'break' }
}

class CatchBlock is export {
    has JavaParameter $.exception;
    has Statement @.block;
}

class Try does SelfTerminating is export {
    has Statement @.try;
    has CatchBlock @.catchers;
    has Statement @.finally;

    method generate(--> Str) {
        my $block = .generate.join(";\n").indent($!indent) for @!try;
        my $code = "try \{\n$block;\n\}";
        for @!catchers {
            my $block = .generate.join(";\n").indent($!indent) for .block;
            $code ~= " catch ({.exception.generate}) \{\n$block;\n}";
        }
        if @!finally {
            my $statements = .generate.join(";\n").indent($!indent) for @!finally;
            $code ~= " finally \{\n$statements;\n\}";
        }
        $code;
    }
}
