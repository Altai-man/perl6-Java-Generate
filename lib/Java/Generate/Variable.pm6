use Java::Generate::Statement;
use Java::Generate::Utils;

unit module Java::Generate::Variable;

class InstanceVariable does Java::Generate::Statement::Variable is export {
    has AccessLevel $.access;

    method generate(--> Str) {
        my $code = "{$!access}{@!modifiers ?? ' ' ~ @!modifiers.join(', ') !! '' } {$!type} {$!name}";
        $code ~  ($!default ?? " = {$!default.generate};" !! ";")
    }

    method reference(--> Str) { "this.{$!name}" }
}

class StaticVariable does Java::Generate::Statement::Variable is export {
    has AccessLevel $.access;
    has $.class;

    method generate(--> Str) {
        my $code = "{$!access} static{@!modifiers ?? ' ' ~ @!modifiers.join(', ') !! '' } {$!type} {$!name}";
        $code ~  ($!default ?? " = {$!default.generate};" !! ";")
    }

    method reference(--> Str) {
        "{$!class}.{$!name}"
    }
}
