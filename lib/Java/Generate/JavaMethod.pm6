use Java::Generate::Expression;
use Java::Generate::Variable;
use Java::Generate::Statement;
use Java::Generate::ASTNode;
use Java::Generate::JavaSignature;
use Java::Generate::Utils;

unit module Java::Generate::JavaMethod;

role JavaMethod does ASTNode is export {
    has JavaSignature $.signature;
    has Int $.indent = 4;
}

class InterfaceMethod does JavaMethod is export {
    has AccessLevel $.access;
    has Str $.name;
    has Str $.return-type;

    method generate(--> Str) {
        "{$!access} {$!return-type} {$!name}();"
    }
}

class ConstructorMethod does JavaMethod is export {
    has Statement @.statements;

    method generate(:$name --> Str) {
        my $code = "{$name}({$!signature.generate()}) \{";
        $code ~= {@!statements.map(*.generate()).join.indent($!indent)} if @!statements;
        $code ~= "\}";
    }
}

class ClassMethod does JavaMethod is export {
    has AccessLevel $.access;
    has Modifier @.modifiers;
    has Statement @.statements;
    has Str $.name;
    has $.return-type;

    method generate(--> Str) {
        my $code = "{$!access}";
        $code ~= ' ' ~ @!modifiers.join(' ') if @!modifiers;
        $code ~= " {$!return-type} {$!name}({$!signature.generate()}) \{\n";
        my LocalVariable %locals = $!signature.parameters.map(
            {
                my $var = LocalVariable.new(name => .name, type => .type);
                $var.initialized = True;
                .name => $var
            }
        ).Hash;
        $code ~= @!statements.map(
            {
                if $_ ~~ VariableDeclaration {
                    # Local
                    my $var = .variable;
                    die "Variable {.variable.name} already declared" if %locals{$var.name};
                    %locals{$var.name} = .variable;
                    %locals{$var.name}.initialized = True if $var.default;
                } elsif $_ ~~ Expression {
                    %locals{.left.name}.initialized = True if $_ ~~ Assignment;
                    for .operands {
                        die "Variable 「$_」 is not declared"     unless %locals{$_};
                        die "Variable 「$_」 is not initialized!" unless %locals{$_}.initialized;
                    }
                }
                my $c = .generate();
                $c.ends-with(';') ?? $c !! $c ~ ';'
            }).join("\n").indent($!indent) if @!statements;
        if (not $!return-type eq 'void') && @!statements[*-1] !~~ Return {
            die "Method {$!name} must return {$!return-type}";
        }
        $code ~= "\n\}\n";
    }
}
