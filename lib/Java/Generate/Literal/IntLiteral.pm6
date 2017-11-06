use Java::Generate::Argument;
use Java::Generate::Utils;

class IntLiteral does Argument {
    has Int $.value;
    has Base $.base;

    method new($value, $base) { self.bless(:$value, :$base) }

    method generate(--> Str) {
        my $int = (-(2 ** 31) <= $!value <= (2 ** 31 - 1));
        if -9223372036854775808 > $!value || $!value > 9223372036854775808 {
            die "Value {$!value} is too {$!value > 0 ?? 'large' !! 'small'} for integer";
        }
        my $signed = $!value < 0 ?? $!value + 2 ** ($int ?? 32 !! 64) !! $!value;
        (given $!base {
            when 'dec' { $!value.Str }
            when 'oct' { '0' ~ $signed.base(8) }
            when 'hex' { '0x' ~ $signed.base(16) }
            when 'bin' {
                my $n = $signed.base(2);
                '0b' ~ ('0' xx (($int ?? 32 !! 64) - $n.Str.chars)).join ~ $n
            }
        }) ~ ($int ?? '' !! 'L');
    }
}
