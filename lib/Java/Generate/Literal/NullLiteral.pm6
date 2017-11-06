use Java::Generate::Argument;

class NullLiteral does Argument {
    method generate(--> Str) { "null" }
}
