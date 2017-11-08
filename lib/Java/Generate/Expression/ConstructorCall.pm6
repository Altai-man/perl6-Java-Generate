use Java::Generate::Expression;
use Java::Generate::Argument;

class ConstructorCall does Expression {
    has Str $.name;
    has Argument @.arguments;

    method generate(--> Str) {
        "new {$!name}({@!arguments.map(*.generate).join(', ')})";
    }
}
