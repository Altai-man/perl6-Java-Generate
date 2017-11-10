use Java::Generate::ASTNode;
use Java::Generate::Utils;

unit module Java::Generate::Statement;

role Statement does ASTNode is export {}

role Expression does Statement is export {
    method operands() {()}
}

role Variable does Expression is export {
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

class If does Statement is export {
    has Expression $.cond;
    has Statement @.true;
    has Statement @.false;
    has Int $.indent = 4;

    method generate(--> Str) {
        my $code = "if {$!cond.generate} \{\n{@!true.map(*.generate).join(";\n").indent($!indent)}\n\}";
        if @!false {
            $code ~= " else \{\n{@!false.map(*.generate).join(";\n").indent($!indent)}\n\}"
        }
        $code;
    }
}

class While  does Statement is export {
    has Expression $.cond;
    has Statement @.task;
    has Int $.indent = 4;

    method generate(--> Str) {
        "while {$!cond.generate} \{\n{@!task.map(*.generate).join(";\n").indent($!indent)}\n\}"
    }
}

# class DoWhile  does Statement is export {}

# class Switch does Statement is export {}

# class For does Statement is export {}

# class Continue does Statement is export {}

# class Break does Statement is export {}

# class Try does Statement is export {}

# class Throw does Statement is export {}
