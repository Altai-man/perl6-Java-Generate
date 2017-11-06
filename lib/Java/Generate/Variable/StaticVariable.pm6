use Java::Generate::Utils;
use Java::Generate::Variable;

class StaticVariable does Variable {
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
