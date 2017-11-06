use Java::Generate::Argument;

unit module Java::Generate::Literal;

class IntLiteral does Argument {
    method generate(--> Str) {''}
}

class FloatLiteral does Argument {
    method generate(--> Str) {''}
}

class StringLiteral does Argument {
    has Str $.value;

    method generate(--> Str) {
        "\"$!value\""
    }
}
