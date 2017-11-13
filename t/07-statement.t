use Java::Generate::Class;
use Java::Generate::Expression;
use Java::Generate::JavaMethod;
use Java::Generate::JavaSignature;
use Java::Generate::Literal;
use Java::Generate::Statement;
use Java::Generate::Variable;
use Test;

plan 8;

sub generates(@statements, $result, $desc) {
    is @statements.map(*.generate).join('\n'), $result, $desc;
}

my $code = "if (1 > 0) \{\n    return true;\n\}";

generates([If.new(
    cond => InfixOp.new(left => IntLiteral.new(1, 'dec'), right => IntLiteral.new(0, 'dec'), op => '>'),
    true => Return.new(return => BooleanLiteral.new(:value)))],
          $code, 'Single if-conditional');

$code = "if (1 > 0) \{\n    return true;\n\} else \{\n    return false;\n\}";

generates([If.new(
    cond => InfixOp.new(left => IntLiteral.new(1, 'dec'), right => IntLiteral.new(0, 'dec'), op => '>'),
    true => Return.new(return => BooleanLiteral.new(:value)),
    false => Return.new(return => BooleanLiteral.new(:!value)))],
          $code, 'if-else conditional');

$code = "while (true) \{\n    0 + 1;\n    return 1;\n\}";

generates([While.new(
    cond => BooleanLiteral.new(:value),
    body => [InfixOp.new(left => IntLiteral.new(0, 'dec'), right => IntLiteral.new(1, 'dec'), op => '+'),
             Return.new(return => IntLiteral.new(1, 'dec'))])],
          $code, 'while statement');

$code = "do \{\n    0 + 1;\n    return 1;\n\} while (true);";

generates([While.new(:after,
                     cond => BooleanLiteral.new(:value),
                     body => [InfixOp.new(
                                     left => IntLiteral.new(0, 'dec'),
                                     right => IntLiteral.new(1, 'dec'),
                                     op => '+'),
                              Return.new(return => IntLiteral.new(1, 'dec'))
                             ]
                    )
          ],
          $code, 'do-while statement');

$code = q/switch (month) {
case 1:
    monthValue = "January";
    break;
case 2:
    monthValue = "February";
    break;
}/;

generates([Switch.new(
                  switch => LocalVariable.new(:name<month>, :type<int>),
                  branches => [IntLiteral.new(1, 'dec') => Assignment.new(
                                      left => LocalVariable.new(:name<monthValue>, :type<string>),
                                      right => StringLiteral.new(:value<January>)),
                               IntLiteral.new(2, 'dec') => Assignment.new(
                                      left => LocalVariable.new(:name<monthValue>, :type<string>),
                                      right => StringLiteral.new(:value<February>)),
                             ]
                    )
          ],
          $code, 'switch-case statement');

$code = "while (true) \{\n    if (1 >= 0) \{\n        break;\n    \}\n\}";

generates([While.new(
    cond => BooleanLiteral.new(:value),
    body => [
             If.new(
                 cond => InfixOp.new(
                     left => IntLiteral.new(1, 'dec'),
                     right => IntLiteral.new(0, 'dec'),
                     op => '>='),
                 true => Break.new)
         ])],
          $code, 'while statement + break');

$code = "while (true) \{\n    if (0 >= 1) \{\n        continue;\n    \}\n\}";

generates([While.new(
    cond => BooleanLiteral.new(:value),
    body => [
             If.new(
                 cond => InfixOp.new(
                     left  => IntLiteral.new(0, 'dec'),
                     right => IntLiteral.new(1, 'dec'),
                     op => '>='),
                 true => Continue.new)])],
          $code, 'while statement + continue');

$code = "for (int i = 0; i < 10; i++) \{\n    System.out.println(i);\n\}";
my $out = StaticVariable.new(
    :name<out>,
    class => 'System'
);

generates([For.new(
    initializer => VariableDeclaration.new('i', 'int', (), IntLiteral.new(0, 'dec')),
    cond => InfixOp.new(
        left => LocalVariable.new(:name<i>),
        right => IntLiteral.new(10, 'dec'),
        op => "<"
    ),
    increment => PostfixOp.new(left => LocalVariable.new(:name<i>), :op<++>),
    body => [MethodCall.new(
        object => $out,
        :name<println>,
        arguments => LocalVariable.new(:name<i>))])],
          $code, 'for loop');
