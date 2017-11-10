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
