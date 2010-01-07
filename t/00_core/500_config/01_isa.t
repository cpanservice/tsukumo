#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Config;

can_ok( 'Tsukumo::Config', qw( decode encode visit interpolate ) );
isa_ok( Tsukumo::Config->new({}), 'Tsukumo::Config' );
