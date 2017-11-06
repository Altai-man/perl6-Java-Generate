use Java::Generate::Literal::IntLiteral;
use Java::Generate::Literal::FloatLiteral;
use Java::Generate::Literal::StringLiteral;
use Test;

plan 29;

is IntLiteral.new(0, 'dec').generate, '0', 'Zero decimal';
is IntLiteral.new(2, 'dec').generate, '2', 'Positive decimal';
is IntLiteral.new(-2, 'dec').generate, '-2', 'Negative decimal';

is IntLiteral.new(8, 'oct').generate, '010', 'Positive octal';
is IntLiteral.new(2147483647, 'oct').generate, '017777777777', 'Maximal octal';
is IntLiteral.new(-2147483648, 'oct').generate, '020000000000', 'Minimal octal';
is IntLiteral.new(-1, 'oct').generate, '037777777777', 'Octal -1';
is IntLiteral.new(-8, 'oct').generate, '037777777770', 'Octal -8';

is IntLiteral.new(10, 'hex').generate, '0xA', 'Positive hex';
is IntLiteral.new(2147483647, 'hex').generate, '0x7FFFFFFF', 'Maximal hex';
is IntLiteral.new(-2147483648, 'hex').generate, '0x80000000', 'Minimal hex';
is IntLiteral.new(-1, 'hex').generate, '0xFFFFFFFF', 'Hexadecimal -1';

is IntLiteral.new(2147483647, 'bin').generate, '0b01111111111111111111111111111111', 'Maximal bin';
is IntLiteral.new(-2147483648, 'bin').generate, '0b10000000000000000000000000000000', 'Minimal bin';
is IntLiteral.new(-1, 'bin').generate, '0b11111111111111111111111111111111', 'Binary -1';

# Long
is IntLiteral.new(2 ** 63 - 1, 'dec').generate, '9223372036854775807L', 'Positive decimal long';
is IntLiteral.new(-2 ** 63, 'dec').generate, '-9223372036854775808L', 'Negative decimal long';

is IntLiteral.new(2 ** 63 - 1, 'oct').generate, '0777777777777777777777L', 'Maximal octal long';
is IntLiteral.new(-2 ** 63, 'oct').generate, '01000000000000000000000L', 'Minimal octal long';

is IntLiteral.new(2 ** 63 - 1, 'hex').generate, '0x7FFFFFFFFFFFFFFFL', 'Maximal hex long';
is IntLiteral.new(-2 ** 63, 'hex').generate, '0x8000000000000000L', 'Minimal hex long';

is IntLiteral.new(2 ** 63 - 1, 'bin').generate, '0b0111111111111111111111111111111111111111111111111111111111111111L', 'Maximal bin long';
is IntLiteral.new(-2 ** 63, 'bin').generate, '0b1000000000000000000000000000000000000000000000000000000000000000L', 'Minimal bin long';

is FloatLiteral.new(value => 10.Num).generate, '10f', 'Float 10';
is FloatLiteral.new(value => 0.3.Num).generate, '0.3f', 'Float 0.3';
is FloatLiteral.new(value => 6.022137e+23.Num).generate, '6.022137e+23f', 'Float';

is StringLiteral.new(value => 'Hello World!').generate, '"Hello World!"', 'ASCII string';
is StringLiteral.new(value => 'Hello, ¥ and Unicode!').generate, '"Hello, \u00A5 and Unicode!"', 'BMP Unicode string';
is StringLiteral.new(value => 'Hello, 𐀀 and non-BMP Unicode!').generate, '"Hello, \uD800\uDC00 and non-BMP Unicode!"', 'Non-BMP Unicode string';
