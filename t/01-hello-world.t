use Java::Generate::Class;
use Java::Generate::JavaMethod;
use Java::Generate::JavaParameter;
use Java::Generate::JavaSignature;
use Java::Generate::Literal;
use Java::Generate::Statement::MethodCall;
use Java::Generate::Variable::StaticVariable;
use Test;

my $signature = JavaSignature.new(
    parameters => JavaParameter.new(:type<String[]>, :name<args>)
);

my $out = StaticVariable.new(
    :name<out>,
    :type<PrintStream>,
    :access-level<public>,
    class => 'System'
);

my $statements = MethodCall.new(
    object => $out,
    :name<println>,
    arguments => Java::Generate::Literal::StringLiteral.new(value => 'Hello, World')
);

my $hello-method = JavaMethod.new(
    :access<public>,
    :name<main>,
    :$signature, :$statements
    :return-type<void>,
    modifiers => 'static'
);

my $hello-class = Class.new(
    :access<public>,
    :name<HelloWorld>,
    methods => $hello-method
);

my $java = qq:to/END/;
public class HelloWorld \{

    public static void main (String[] args) \{
        System.out.println("Hello, World");
    \}

\}
END

is $hello-class.generate, $java, 'Hello World is generated';
