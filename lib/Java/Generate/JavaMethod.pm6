use Java::Generate::ASTNode;
use Java::Generate::JavaSignature;
use Java::Generate::Statement;
use Java::Generate::Utils;

unit module Java::Generate::JavaMethod;

role JavaMethod does ASTNode is export {
    has Str $.name;
    has JavaSignature $.signature;
}

class InterfaceMethod does JavaMethod is export {
    has AccessLevel $.access;
    has Str $.return-type;

    method generate(--> Str) {
        "{$!access} {$!return-type} {$!name}();"
    }
}

class ConstructorMethod does JavaMethod is export {
    has Statement @.statements;

    method generate(--> Str) {
        my $code = "{$!name}({$!signature.generate()}) \{";
        $code ~= "{@!statements.map(*.generate()).join.indent(4)}" if @!statements;
        $code ~= "\}";
    }
}

class ClassMethod does JavaMethod is export {
    has AccessLevel $.access;
    has Statement @.statements;
    has Modifier @.modifiers;
    has Str $.return-type;

    method generate(--> Str) {
        my $code = "{$!access}";
        $code ~= ' ' ~ @!modifiers.join(' ') if @!modifiers;
        $code ~= " {$!return-type} {$!name}({$!signature.generate()}) \{\n";
        $code ~= @!statements.map(*.generate()).join("\n").indent(4) if @!statements;
        $code ~= "\n\}\n";
    }
}
