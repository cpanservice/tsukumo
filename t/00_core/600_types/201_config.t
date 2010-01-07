#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Tsukumo::Types qw( Config );

is( Config, 'Tsukumo::Types::Config' );

ok( Config->check( Tsukumo::Config->new({}) ) );
ok( ! Config->check({}) );

is_deeply(
    Config->coerce({}),
    Tsukumo::Config->new({}),
);
