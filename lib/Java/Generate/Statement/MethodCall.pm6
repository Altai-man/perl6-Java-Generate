use Java::Generate::Argument;
use Java::Generate::Statement;
use Java::Generate::Variable;

class MethodCall does Statement {
    has Variable $.object;
    has Str $.name;
    has Argument @.arguments;

    method generate(--> Str) {
        "{$!object.generate-caller()}.{$!name}({@!arguments.map(*.generate).join(', ')});";
    }
}
