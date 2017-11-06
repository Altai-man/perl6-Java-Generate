use Java::Generate::Argument;
use Java::Generate::Utils;

unit module Java::Generate::Literal;

class IntLiteral does Argument {
    has Int $.value;
    has Base $.base;

    method new($value, $base) { self.bless(:$value, :$base) }

    method generate(--> Str) {
        my $int = (-(2 ** 31) <= $!value <= (2 ** 31 - 1));
        (given $!base {
            when 'dec' {
                $!value.Str
            }
            when 'oct' {
                '0' ~ ($!value < 0 ?? $!value + 2 ** ($int ?? 32 !! 64) !! $!value).base(8)
            }
            when 'hex' {
                '0x' ~ ($!value < 0 ?? $!value + 2 ** ($int ?? 32 !! 64) !! $!value).base(16)
            }
            when 'bin' {
                my $n = ($!value < 0 ?? $!value + 2 ** ($int ?? 32 !! 64) !! $!value).base(2);
                '0b' ~ ('0' xx (($int ?? 32 !! 64) - $n.Str.chars)).join ~ $n
            }
        }) ~ ($int ?? '' !! 'L');
    }
}

class FloatLiteral does Argument {
    method generate(--> Str) {''}
}

class StringLiteral does Argument {
    has Str $.value;

    method generate(--> Str) {
        "\"$!value\""
    }
}
