use Java::Generate::Argument;
use Java::Generate::Utils;

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
