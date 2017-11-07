use Java::Generate::Variable;
use Java::Generate::Class;
use Test;

plan *;

my @fields = InstanceVariable.new(:name<field_a>, :type<int>, :access<public>, :default<5>),
             InstanceVariable.new(:name<field_b>, :type<int>, :access<public>);

my @static-fields = StaticVariable.new(:name<field_c>, :type<float>,  :access<public>, default => 3.2, class => 'A'),
                    StaticVariable.new(:name<field_d>, :type<Custom>, :access<private>, class => 'A');

my $class-a = Class.new(
    :access<public>,
    :name<A>,
    :@fields,
    :@static-fields
);

my $code = qq:to/END/;
public class A \{

    public static float field_c = 3.2;
    private static Custom field_d;
    public int field_a = 5;
    public int field_b;

\}
END

is $class-a.generate, $code, 'Class with fields';

done-testing;
