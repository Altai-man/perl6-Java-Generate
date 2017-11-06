use Java::Generate::Utils;
use Java::Generate::Variable;

class InstanceVariable does Variable {
    has AccessLevel $.access-level;
    has $.default;

    method generate(--> Str) {
        $!default ??
        "{$!access-level} {$!type} {$!name} = {$!default};" !!
        "{$!access-level} {$!type} {$!name};";
    }
}
