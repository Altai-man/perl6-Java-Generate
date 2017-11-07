use Java::Generate::ASTNode;
use Java::Generate::Utils;

unit module Java::Generate::Variable;

role Variable does ASTNode is export {
    has $.name;
    has $.type;

    method reference(--> Str) { "{$!name}" }
}

class InstanceVariable does Variable is export {
    has AccessLevel $.access-level;
    has $.default;

    method generate(--> Str) {
        $!default ??
        "{$!access-level} {$!type} {$!name} = {$!default};" !!
        "{$!access-level} {$!type} {$!name};";
    }
}

class StaticVariable does Variable is export {
    has AccessLevel $.access-level;
    has $.default;
    has $.class;

    method generate(--> Str) {
        $!default ??
        "{$!access-level} static {$!type} {$!name} = {$!default};" !!
        "{$!access-level} static {$!type} {$!name};";
    }

    method generate-caller(--> Str) {
        "{$!class}.{$!name}"
    }
}
