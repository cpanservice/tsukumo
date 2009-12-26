#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Class::Date;

isa_ok( localtime(0), 'Tsukumo::Class::Date' );
ok( localtime->isa('Time::Piece') );
