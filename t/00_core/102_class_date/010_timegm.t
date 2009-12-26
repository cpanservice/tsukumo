#!perl

use strict;
use warnings;

use Tsukumo::Class::Date ();
use Test::More tests => 2;

my $time = Tsukumo::Class::Date->timegm( 0, 0, 0, 1, 0, 1970 );

isa_ok( $time, 'Tsukumo::Class::Date' );

is(
    $time->datetime,
    '1970-01-01T00:00:00',
);