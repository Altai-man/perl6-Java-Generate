use Java::Generate::Argument;
use Java::Generate::Utils;

unit module Java::Generate::Literal;

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

class FloatLiteral does Argument {
    has Num $.value;

    method generate(--> Str) {
        my $float = 1.40e-45 <= $!value <= 3.4028235e38;
        # XXX: the actual minimal number from spec is `4.9e-324`,
        # but it evaluates to 0 currently (possible Rakudo), so using some bigger number instead;
        if 1.7976931348623157e308 < $!value || $!value < 4.9e-323 {
            die "Value {$!value} is too {$!value > 1 ?? 'large' !! 'small'} for double";
        }
        $!value.Str ~ ($float ?? 'f' !! 'd');
    }
}

class StringLiteral does Argument {
    has Str $.value;

    method !expand($_) { (0 xx (4 - $_.chars)).join ~ $_ }

    method !non-bmp-sequence($_) {
        my $high = ((($_ - 0x10000) / 0x400) + 0xD800).floor.base(16);
        my $low  =  (($_ - 0x10000) % 0x400 + 0xDC00).base(16);
        qq/\\u$high\\u$low/;
    }

    method generate(--> Str) {
        my $converted = $!value.comb.map(
            {
                my $ord = .ord;
                $ord < 127 ??
                $_ !!
                $ord < 65535 ??
                    '\u' ~ self!expand($ord.base(16)) !!
                    self!non-bmp-sequence($ord);

            }).join;
        qq/"$converted"/
    }
}

class NullLiteral does Argument {
    method generate(--> Str) { "null" }
}

class BooleanLiteral does Argument {
    has Bool $.value;

    method generate(--> Str) { $!value ?? 'true' !! 'false' }
}
