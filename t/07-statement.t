use Java::Generate::Class;
use Java::Generate::Expression;
use Java::Generate::JavaMethod;
use Java::Generate::JavaSignature;
use Java::Generate::Literal;
use Java::Generate::Statement;
use Java::Generate::Variable;
use Test;

plan 5;

sub generates(@statements, $result, $desc) {
    is @statements.map(*.generate).join('\n'), $result, $desc;
}

my $code = "if 1 > 0 \{\n    return true;\n\}";

generates([If.new(
    cond => InfixOp.new(left => IntLiteral.new(1, 'dec'), right => IntLiteral.new(0, 'dec'), op => '>'),
    true => Return.new(return => BooleanLiteral.new(:value)))],
          $code, 'Single if-conditional');

$code = "if 1 > 0 \{\n    return true;\n\} else \{\n    return false;\n\}";

generates([If.new(
    cond => InfixOp.new(left => IntLiteral.new(1, 'dec'), right => IntLiteral.new(0, 'dec'), op => '>'),
    true => Return.new(return => BooleanLiteral.new(:value)),
    false => Return.new(return => BooleanLiteral.new(:!value)))],
          $code, 'if-else conditional');

$code = "while (true) \{\n    0 + 1;\n    return 1;\n\}";

generates([While.new(
    cond => BooleanLiteral.new(:value),
    task => [InfixOp.new(left => IntLiteral.new(0, 'dec'), right => IntLiteral.new(1, 'dec'), op => '+'),
             Return.new(return => IntLiteral.new(1, 'dec'))])],
          $code, 'while statement');

$code = "do \{\n    0 + 1;\n    return 1;\n\} while (true)";

generates([While.new(:after,
                     cond => BooleanLiteral.new(:value),
                     task => [InfixOp.new(
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
