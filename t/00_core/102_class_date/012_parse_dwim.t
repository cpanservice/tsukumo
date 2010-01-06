#!perl

use strict;
use warnings;

use Tsukumo::Class::Date;
use Test::More tests => 8;

my $date = Tsukumo::Class::Date->parse_dwim('2009-12-24T10:20:30Z');

isa_ok( $date, 'Tsukumo::Class::Date' );
is( $date->year, 2009 );
is( $date->month, 12 );
is( $date->day, 24 );
is( $date->hour, 10 );
is( $date->minute, 20 );
is( $date->second, 30 );
is( $date->tzoffset, 0 );
