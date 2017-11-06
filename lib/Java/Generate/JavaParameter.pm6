use Java::Generate::ASTNode;

class JavaParameter does ASTNode {
    has Str $.name;
    has Str $.type;

    method generate(--> Str) {
        "{$!type} {$!name}"
    }
}
