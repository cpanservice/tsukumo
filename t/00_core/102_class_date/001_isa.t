#!perl

use strict;
use warnings;

use Test::More tests => 1;
use Tsukumo::Class::Date;

isa_ok( Tsukumo::Class::Date->new( epoch => time ), 'Tsukumo::Class::Date' );
