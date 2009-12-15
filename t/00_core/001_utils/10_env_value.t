#!perl

use strict;
use warnings;

use Tsukumo::Utils qw( env_value );
use Test::More tests => 2;

local $ENV{'TSUKUMO_FOO'} = 'bar';
local $ENV{'TSUKUMO_BAR'};

is( env_value('foo'), 'bar' );

ok( ! env_value('bar') );
