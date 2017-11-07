use Java::Generate::ASTNode;
use Java::Generate::Interface;
use Java::Generate::JavaMethod;
use Java::Generate::Utils;
use Java::Generate::Variable;

class Class does ASTNode {
    has AccessLevel $.access;
    has Str $.name;
    has InstanceVariable @.fields;
    has StaticVariable @.static-fields;
    has ClassMethod @.methods;
    has Class $.super;
    has Interface @.interfaces;

    method generate(--> Str) {
        my $interfaces-to-implement = @!interfaces.Array;
        my @methods-to-implement;
        for @$interfaces-to-implement {
            @methods-to-implement.append: .methods.map(*.name);
            $interfaces-to-implement.append: .interfaces;
        }
        unless (@methods-to-implement.Set (<=) @!methods.map(*.name).Set) {
            my $methods = (@methods-to-implement.Set (-) @!methods.Set).keys.join(', ');
            die "Class {$!name} must implement: $methods";
        }

        qq:to/END/;
        $!access class {$!name}{@!interfaces ?? ' implements ' ~ @!interfaces.map(*.name).join(', ') !! '' }{$!super ?? ' extends ' ~ $!super.name !! ''} \{

        @!static-fields.map(*.generate()).join("\n").indent(4)
        @!fields.map(*.generate()).join("\n").indent(4)
        @!methods.map(*.generate()).join("\n").indent(4)
        \}
        END
    }
}
