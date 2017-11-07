use Java::Generate::ASTNode;
use Java::Generate::JavaSignature;
use Java::Generate::Statement;
use Java::Generate::Utils;

unit module Java::Generate::JavaMethod;

role JavaMethod does ASTNode is export {
    has AccessLevel $.access;
    has Str $.name;
    has JavaSignature $.signature;
    has Str $.return-type;
}

class InterfaceMethod does JavaMethod is export {
    method generate(--> Str) {
        qq:to/END/;
        {$!access} {$!return-type} {$!name}();
        END
    }
}

class ClassMethod does JavaMethod is export {
    has Statement @.statements;
    has Modifier @.modifiers;

    method generate(--> Str) {
        qq:to/END/;
        {$!access} {@!modifiers.join(' ')} {$!return-type} {$!name} ({$!signature.generate()}) \{
            {@.statements.map(*.generate())}
        \}
        END
    }
}
