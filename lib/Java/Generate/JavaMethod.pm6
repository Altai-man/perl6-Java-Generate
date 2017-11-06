use Java::Generate::ASTNode;
use Java::Generate::JavaSignature;
use Java::Generate::Statement;
use Java::Generate::Utils;

class JavaMethod does ASTNode {
    has AccessLevel $.access;
    has Str $.name;
    has JavaSignature $.signature;
    has Statement @.statements;
    has Str $.return-type;
    has Modifier @.modifiers;

    method generate(--> Str) {
        qq:to/END/;
        {$!access} {@!modifiers.join(' ')} {$!return-type} {$!name} ({$!signature.generate()}) \{
            {@.statements.map(*.generate())}
        \}
        END
    }
}
