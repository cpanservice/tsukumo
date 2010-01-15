#!perl

use strict;
use warnings;

use Test::More;
use Tsukumo::Types::Formatter qw(
    Formatter
    PerlFormatter YAMLFormatter PlainTextFormatter
);

my %tests = (
    Formatter => {
        meta => Formatter,
    },
    Perl => {
        meta => PerlFormatter,
    },
    YAML => {
        meta => YAMLFormatter,
    },
    PlainText => {
        meta => PlainTextFormatter,
    },
);

for my $name ( keys %tests ) {
    my $meta    = $tests{$name}->{'meta'};
    my $format  = ( $name eq 'Formatter' ) ? 'PlainText' : $name;
       $name    = q{} if ( $name eq 'Formatter' );

    is( $meta, "Tsukumo::Types::Formatter::${name}Formatter" );


    ok( $meta->check( Tsukumo::Format->new( format => $format ) ) );
    ok( ! $meta->check({}) );

    isa_ok( $meta->coerce($format), "Tsukumo::Format::${format}" ) if ( $name eq 'Formatter' );
    isa_ok( $meta->coerce([ format => $format ]),      "Tsukumo::Format::${format}" );
    isa_ok( $meta->coerce({ format => $format }),      "Tsukumo::Format::${format}" );
}

done_testing;
