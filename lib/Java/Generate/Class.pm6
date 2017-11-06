use Java::Generate::ASTNode;
use Java::Generate::JavaMethod;
use Java::Generate::Utils;
use Java::Generate::Variable::InstanceVariable;
use Java::Generate::Variable::StaticVariable;

class Class does ASTNode {
    has AccessLevel $.access;
    has Str $.name;
    has InstanceVariable @.fields;
    has StaticVariable @.static-fields;
    has JavaMethod @.methods;

    method generate(--> Str) {
        qq:to/END/;
        $!access class $!name \{

        @!methods.map(*.generate()).join("\n\n").indent(4)
        \}
        END
    }
}
