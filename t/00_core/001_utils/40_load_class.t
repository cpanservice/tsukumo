#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Utils qw( load_class );

ok( load_class('Tsukumo::Class::Variables') );
ok( exists $INC{'Tsukumo/Class/Variables.pm'} );