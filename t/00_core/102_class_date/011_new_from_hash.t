#!perl

use strict;
use warnings;

use Tsukumo::Class::Date;
use Test::More tests => 2;

my $time = Tsukumo::Class::Date->new_from_hash(
    year    => 2009,
    month   => 12,
    day     => 24,
    hour    => 10,
    minute  => 20,
    second  => 30,
    offset  => 9 * 60 * 60,
);

isa_ok( $time, 'Tsukumo::Class::Date' );

is(
    $time->datetime,
    '2009-12-24T19:20:30',
);