use Java::Generate::ASTNode;
use Java::Generate::Utils;

unit module Java::Generate::Variable;

role Variable does ASTNode is export {
    has $.name;
    has $.type;
    has Modifier @.modifiers;

    method reference(--> Str) { "{$!name}" }
}

class InstanceVariable does Variable is export {
    has AccessLevel $.access;
    has $.default;

    method generate(--> Str) {
        my $res = "{$!access}{@!modifiers ?? ' ' ~ @!modifiers.join(', ') !! '' } {$!type} {$!name}";
        $res ~  ($!default ?? " = {$!default};" !! ";")
    }
}

class StaticVariable does Variable is export {
    has AccessLevel $.access;
    has $.default;
    has $.class;

    method generate(--> Str) {
        my $res = "{$!access} static{@!modifiers ?? ' ' ~ @!modifiers.join(', ') !! '' } {$!type} {$!name}";
        $res ~  ($!default ?? " = {$!default};" !! ";")
    }

    method generate-caller(--> Str) {
        "{$!class}.{$!name}"
    }
}
