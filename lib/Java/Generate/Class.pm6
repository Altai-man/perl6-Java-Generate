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
    has ConstructorMethod @.constructors;
    has Class $.super;
    has Interface @.interfaces;
    has Modifier @.modifiers;
    has Int $.indent = 4;

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

        my $code = $!access ?? "{$!access} " !! '';
        $code ~= "{@!modifiers} " if @!modifiers;
        $code ~= "class {$!name}";
        $code ~= ' implements ' ~ @!interfaces.map(*.name).join(', ') if @!interfaces;
        $code ~= " extends {$!super.name}" if $!super;
        $code ~= " \{\n\n";
        $code ~= @!static-fields.map(*.generate()).join("\n").indent($!indent) ~ "\n" if @!static-fields;
        $code ~= @!fields.map(*.generate()).join("\n").indent($!indent) ~ "\n" if @!fields;
        $code ~= @!constructors.map(*.generate()).join("\n").indent($!indent) ~ "\n" if @!constructors;
        $code ~= @!methods.map(*.generate()).join("\n").indent($!indent) ~ "\n" if @!methods;
        $code ~= "}\n";
    }
}
