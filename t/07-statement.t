use Java::Generate::Class;
use Java::Generate::Expression;
use Java::Generate::JavaMethod;
use Java::Generate::JavaSignature;
use Java::Generate::Literal;
use Java::Generate::Statement;
use Test;

plan 2;

sub generates(@statements, $result) {
    my $signature = JavaSignature.new(:parameters());
    my @methods = ClassMethod.new(
        :$signature, :access<public>,
        :name<a>, :return-type<boolean>,
        :@statements);    
    my $class = Class.new(:access<public>, :name<A>, :@methods);
    $class.generate eq $result;
}

my $code = q:to/END/;
public class A {

    public boolean a() {
        if 1 > 0 {
            return true;
        };
    }

}
END

ok generates([If.new(
    cond => InfixOp.new(left => IntLiteral.new(1, 'dec'), right => IntLiteral.new(0, 'dec'), op => '>'),
    true => Return.new(return => BooleanLiteral.new(:value)))],
             $code), 'Single if-conditional';

$code = q:to/END/;
public class A {

    public boolean a() {
        while true {
            0 + 1;
            return 1;
        };
    }

}
END

ok generates([While.new(
    cond => BooleanLiteral.new(:value),
    task => [InfixOp.new(left => IntLiteral.new(0, 'dec'), right => IntLiteral.new(1, 'dec'), op => '+'),
             Return.new(return => IntLiteral.new(1, 'dec'))]
                 )],
              $code), 'while statement';
