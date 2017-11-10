use Java::Generate::ASTNode;
use Java::Generate::Utils;
use Java::Generate::JavaMethod;

class Interface does ASTNode {
    has AccessLevel $.access;
    has Str $.name;
    has Interface @.interfaces;
    has InterfaceMethod @.methods;
    has Int $.indent = 4;

    method generate(--> Str) {
        my $code = "$!access interface {$!name}";
        $code ~= ' extends ' ~ @!interfaces.map(*.name).join(', ') if @!interfaces;
        $code ~= " \{";
        $code ~= "\n" ~ @!methods.map(*.generate).join("\n").indent($!indent) if @!methods;
        $code ~= "\n\}\n";
    }
}
