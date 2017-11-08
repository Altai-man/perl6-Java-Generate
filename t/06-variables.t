use Java::Generate::Variable;
use Java::Generate::JavaSignature;
use Java::Generate::JavaMethod;
use Java::Generate::Statement;
use Test;

plan 1;

my $code;

$code = qq:to/END/;
public void foo() \{
    final int a;
    int b = 5;
    double c;
\}
END

my $signature1 = JavaSignature.new(:parameters());
my $variable = LocalVariable.new(:name<a>, :modifiers<final>, :type<int>);
my @statements = VariableDeclaration.new($variable),
                 VariableDeclaration.new('b', 'int', (), 5),
                 VariableDeclaration.new('c', 'double', ());
my $method = ClassMethod.new(:access<public>, :name<foo>,
                             signature => $signature1, :return-type<void>,
                             :@statements);

is $method.generate, $code, 'Method with declarations is generated';
