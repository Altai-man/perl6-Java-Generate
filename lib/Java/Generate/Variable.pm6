use Java::Generate::ASTNode;
use Java::Generate::Utils;

unit module Java::Generate::Variable;

role Variable does ASTNode is export {
    has $.name;
    has $.type;
    has $.default;
    has Modifier @.modifiers;

    method reference(--> Str) { "{$!name}" }
}

class InstanceVariable does Variable is export {
    has AccessLevel $.access;

    method generate(--> Str) {
        my $code = "{$!access}{@!modifiers ?? ' ' ~ @!modifiers.join(', ') !! '' } {$!type} {$!name}";
        $code ~  ($!default ?? " = {$!default};" !! ";")
    }
}

class StaticVariable does Variable is export {
    has AccessLevel $.access;
    has $.class;

    method generate(--> Str) {
        my $code = "{$!access} static{@!modifiers ?? ' ' ~ @!modifiers.join(', ') !! '' } {$!type} {$!name}";
        $code ~  ($!default ?? " = {$!default};" !! ";")
    }

    method reference(--> Str) {
        "{$!class}.{$!name}"
    }
}

class LocalVariable does Variable is export {
    method generate() {
        my $code = @!modifiers.join(', ') ~ ' ' if @!modifiers;
        $code ~= "{$!type} {$!name}";
        $code ~= $!default ?? " = {$!default};" !! ";"
    }
}
