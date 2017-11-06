use Java::Generate::Literal;
use Test;

plan 23;

is Java::Generate::Literal::IntLiteral.new(0, 'dec').generate, '0', 'Zero decimal';
is Java::Generate::Literal::IntLiteral.new(2, 'dec').generate, '2', 'Positive decimal';
is Java::Generate::Literal::IntLiteral.new(-2, 'dec').generate, '-2', 'Negative decimal';

is Java::Generate::Literal::IntLiteral.new(8, 'oct').generate, '010', 'Positive octal';
is Java::Generate::Literal::IntLiteral.new(2147483647, 'oct').generate, '017777777777', 'Maximal octal';
is Java::Generate::Literal::IntLiteral.new(-2147483648, 'oct').generate, '020000000000', 'Minimal octal';
is Java::Generate::Literal::IntLiteral.new(-1, 'oct').generate, '037777777777', 'Octal -1';
is Java::Generate::Literal::IntLiteral.new(-8, 'oct').generate, '037777777770', 'Octal -8';

is Java::Generate::Literal::IntLiteral.new(10, 'hex').generate, '0xA', 'Positive hex';
is Java::Generate::Literal::IntLiteral.new(2147483647, 'hex').generate, '0x7FFFFFFF', 'Maximal hex';
is Java::Generate::Literal::IntLiteral.new(-2147483648, 'hex').generate, '0x80000000', 'Minimal hex';
is Java::Generate::Literal::IntLiteral.new(-1, 'hex').generate, '0xFFFFFFFF', 'Hexadecimal -1';

is Java::Generate::Literal::IntLiteral.new(2147483647, 'bin').generate, '0b01111111111111111111111111111111', 'Maximal bin';
is Java::Generate::Literal::IntLiteral.new(-2147483648, 'bin').generate, '0b10000000000000000000000000000000', 'Minimal bin';
is Java::Generate::Literal::IntLiteral.new(-1, 'bin').generate, '0b11111111111111111111111111111111', 'Binary -1';

# Long
is Java::Generate::Literal::IntLiteral.new(2 ** 63 - 1, 'dec').generate, '9223372036854775807L', 'Positive decimal long';
is Java::Generate::Literal::IntLiteral.new(-2 ** 63, 'dec').generate, '-9223372036854775808L', 'Negative decimal long';

is Java::Generate::Literal::IntLiteral.new(2 ** 63 - 1, 'oct').generate, '0777777777777777777777L', 'Maximal octal long';
is Java::Generate::Literal::IntLiteral.new(-2 ** 63, 'oct').generate, '01000000000000000000000L', 'Minimal octal long';

is Java::Generate::Literal::IntLiteral.new(2 ** 63 - 1, 'hex').generate, '0x7FFFFFFFFFFFFFFFL', 'Maximal hex long';
is Java::Generate::Literal::IntLiteral.new(-2 ** 63, 'hex').generate, '0x8000000000000000L', 'Minimal hex long';

is Java::Generate::Literal::IntLiteral.new(2 ** 63 - 1, 'bin').generate, '0b0111111111111111111111111111111111111111111111111111111111111111L', 'Maximal bin long';
is Java::Generate::Literal::IntLiteral.new(-2 ** 63, 'bin').generate, '0b1000000000000000000000000000000000000000000000000000000000000000L', 'Minimal bin long';
