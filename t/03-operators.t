use Java::Generate::Expression::Operator;
use Java::Generate::Literal;
use Java::Generate::Variable;
use Test;

plan 7;

my ($left, $right);

# Variable = Variable
$left  = InstanceVariable.new(:name<a>);
$right = InstanceVariable.new(:name<b>);
is Assignment.new(:$left, :$right).generate, 'a = b', "Variable = Variable";

# Variable = Expression
$left  = InstanceVariable.new(:name<a>);
$right = BinOp.new(left => IntLiteral.new(10, 'dec'), right => IntLiteral.new(5, 'dec'), :op<+>);
is Assignment.new(:$left, :$right).generate, 'a = 10 + 5', "Variable = Expression";

# Variable = Literal
$left  = InstanceVariable.new(:name<a>);
$right = IntLiteral.new(10, 'oct');
is Assignment.new(:$left, :$right).generate, 'a = 012', "Variable = Literal";

# Variable op Variable
$left  = InstanceVariable.new(:name<a>);
$right = InstanceVariable.new(:name<b>);
is BinOp.new(:$left, :$right, :op<^>).generate, 'a ^ b', "Variable op Variable";

# Variable op Literal
$left  = InstanceVariable.new(:name<a>);
$right = IntLiteral.new(15, 'hex');
is BinOp.new(:$left, :$right, :op<->).generate, 'a - 0xF', "Variable op Literal";

# Variable op Expr
$left  = InstanceVariable.new(:name<a>);
$right = BinOp.new(left => IntLiteral.new(10, 'dec'), right => IntLiteral.new(5, 'dec'), :op<+>);
is BinOp.new(:$left, :$right, :op<->).generate, 'a - 10 + 5', "Variable op Literal";

my $cond  = BinOp.new(left => IntLiteral.new(10, 'dec'), right => IntLiteral.new(5, 'dec'), op => '>');
my $true  = InstanceVariable.new(:name<a>);
my $false = InstanceVariable.new(:name<b>);
is Ternary.new(:$cond, :$true, :$false).generate, '10 > 5 ? a : b', "Ternary operator";
