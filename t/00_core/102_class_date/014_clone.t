#!perl

use strict;
use warnings;

use Tsukumo::Class::Date;
use Test::More tests => 1;

my $date  = Tsukumo::Class::Date->now;
my $clone = $date->clone;

is( $date->epoch, $clone->epoch );

