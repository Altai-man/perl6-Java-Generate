use Java::Generate::Class;
use Java::Generate::Expression::ConstructorCall;
use Java::Generate::Expression::Operator;
use Java::Generate::JavaMethod;
use Java::Generate::JavaParameter;
use Java::Generate::JavaSignature;
use Java::Generate::Literal;
use Java::Generate::Variable;
use Test;

plan 4;

my @fields = InstanceVariable.new(:name<field_a>, :type<int>, :access<public>, :default<5>),
             InstanceVariable.new(:name<field_b>, :type<int>, :access<public>);

my @static-fields = StaticVariable.new(:name<field_c>, :type<float>,  :access<public>, default => 3.2, class => 'A'),
                    StaticVariable.new(:name<field_d>, :type<Custom>, :access<private>, class => 'A');

my $class-a = Class.new(
    :access<public>,
    :name<A>,
    :@fields,
    :@static-fields,
    modifiers => <static final>
);

my $code = qq:to/END/;
public static final class A \{

    public static float field_c = 3.2;
    private static Custom field_d;
    public int field_a = 5;
    public int field_b;
\}
END

is $class-a.generate, $code, 'Class with fields';

$code = qq:to/END/;
public class Student \{

    Student(int i, String n) \{\}
    Student(int i, String n, int a) \{\}
\}
END

my $constructor1 = JavaSignature.new(:parameters(JavaParameter.new('i', 'int'),
                                                 JavaParameter.new('n', 'String')));
my $constructor2 = JavaSignature.new(:parameters(JavaParameter.new('i', 'int'),
                                                 JavaParameter.new('n', 'String'),
                                                 JavaParameter.new('a', 'int')));

my @constructors = ConstructorMethod.new(:name<Student>, signature => $constructor1),
                   ConstructorMethod.new(:name<Student>, signature => $constructor2);

my $class-student = Class.new(
    :access<public>,
    :name<Student>,
    :@constructors
);

is $class-student.generate, $code, 'Class with constructors';

$code = qq:to/END/;
class MyPackage \{

\}
END

my $class-my-package = Class.new(:access(''), :name<MyPackage>);

is $class-my-package.generate, $code, 'Class with package access level';

$code = "count > 1 ? new Student(\"Name\") : new Student(\"Name\", 1)";

my $cond  = InfixOp.new(left => InstanceVariable.new(:name<count>), right => IntLiteral.new(1, 'dec'), op => '>');
my $true  = ConstructorCall.new(:name<Student>, arguments => StringLiteral.new(value => 'Name'));
my $false = ConstructorCall.new(:name<Student>, arguments => [StringLiteral.new(value => 'Name'), IntLiteral.new(1, 'dec')]);
is Ternary.new(:$cond, :$true, :$false).generate, $code, "new operator";
