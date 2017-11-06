use Java::Generate::ASTNode;

role Variable does ASTNode {
    has $.name;
    has $.type;
}
