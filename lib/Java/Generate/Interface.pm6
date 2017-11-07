use Java::Generate::ASTNode;
use Java::Generate::Utils;
use Java::Generate::JavaMethod;

class Interface does ASTNode {
    has AccessLevel $.access;
    has Str $.name;
    has Interface @.interfaces;
    has InterfaceMethod @.methods;

    method generate(--> Str) {
        qq:to/END/;
        $!access interface {$!name}{@!interfaces ?? ' extends ' ~ @!interfaces.map(*.name).join(', ') !! '' } \{
        {@!methods.map(*.generate).join.indent(4)}\}
        END
    }
}
