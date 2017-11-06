use Java::Generate::Argument;

class BooleanLiteral does Argument {
    has Bool $.value;

    method generate(--> Str) { $!value ?? 'true' !! 'false' }
}
