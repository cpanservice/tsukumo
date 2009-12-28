#!perl

use strict;
use warnings;

use Tsukumo::Class::Date;
use Test::More tests => 2;

my $date = Tsukumo::Class::Date->now;

isa_ok( $date, 'Tsukumo::Class::Date' );
ok( $date->epoch <= time );
