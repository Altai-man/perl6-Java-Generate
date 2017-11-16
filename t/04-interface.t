use Java::Generate::Class;
use Java::Generate::Interface;
use Java::Generate::JavaParameter;
use Java::Generate::JavaMethod;
use Java::Generate::JavaSignature;
use Test;

plan 7;

my ($code, $signature, @methods);

$code = q:to/END/;
public interface Animal {
    public void eat();
    public void travel();
}
END

$signature = JavaSignature.new(:parameters());

@methods = InterfaceMethod.new(:access<public>, :name<eat>,    :return-type<void>, :$signature),
           InterfaceMethod.new(:access<public>, :name<travel>, :return-type<void>, :$signature);

my $interface-a = Interface.new(:access<public>, :name<Animal>, :@methods);
is $interface-a.generate, $code, 'Interface is generated';

$code = q:to/END/;
public interface Mammal extends Animal {
}
END

my $interface-b = Interface.new(:access<public>, :name<Mammal>, interfaces => $interface-a);
is $interface-b.generate, $code, 'Extended interface is generated';

my $class-a = Class.new(
    :access<public>,
    :name<A>,
    interfaces => $interface-b,
    :check-implementation
);

dies-ok { $class-a.generate }, 'Class checks methods implementation if set';

$class-a = Class.new(
    :access<public>,
    :name<A>,
    interfaces => $interface-b
);

lives-ok { $class-a.generate }, 'Class doesn\'t implementation by default';

@methods = ClassMethod.new(:access<public>, :name<eat>,    :$signature, :return-type<void>),
           ClassMethod.new(:access<public>, :name<travel>, :$signature, :return-type<void>);

my $class-b = Class.new(
    :access<public>,
    :name<B>,
    :@methods,
    interfaces => $interface-b
);


$code = q:to/END/;
public class B implements Mammal {

    public void eat() {

    }

    public void travel() {

    }

}
END

is $class-b.generate, $code, 'Class implementing interface is generated';

my $class-c = Class.new(
    :access<public>,
    :name<C>,
    super => $class-b
);

$code = q:to/END/;
public class C extends B {

}
END

is $class-c.generate, $code, 'Extended class is generated';


$code = q:to/END/;
public interface Animal {
    public void eat(int type, String sound);
}
END

$signature = JavaSignature.new(:parameters(
                                   JavaParameter.new('type', 'int'),
                                   JavaParameter.new('sound', 'String')));

my $interface = Interface.new(
    :access<public>,
    :name<Animal>,
    methods => InterfaceMethod.new(
        :access<public>,
        :name<eat>,
        :return-type<void>,
        :$signature));
is $interface.generate, $code, 'Interface with non-empty signature is generated correctly';
