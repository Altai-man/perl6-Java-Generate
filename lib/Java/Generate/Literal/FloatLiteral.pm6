use Java::Generate::Argument;
use Java::Generate::Utils;

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
