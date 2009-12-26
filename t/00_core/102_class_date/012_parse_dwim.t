#!perl

use strict;
use warnings;

use Tsukumo::Class::Date;
use Test::More tests => 2;

my $time = Tsukumo::Class::Date->parse_dwim('2009-12-24T10:20:30Z');

isa_ok( $time, 'Tsukumo::Class::Date' );
is(
    $time->datetime,
    '2009-12-24T10:20:30',
)