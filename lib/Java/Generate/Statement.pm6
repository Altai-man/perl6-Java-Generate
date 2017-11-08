use Java::Generate::ASTNode;
use Java::Generate::Variable;

unit module Java::Generate::Statement;

role Statement does ASTNode is export {}

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
