#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Utils qw( load_class is_class_loaded );

ok( load_class('Tsukumo::Class::Variables') );
ok( is_class_loaded('Tsukumo::Class::Variables') );
