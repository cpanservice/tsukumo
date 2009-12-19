#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Exceptions;

local $@;
eval { Tsukumo::Exception->throw( error => 'test exception' ) };

isa_ok( $@, 'Tsukumo::Exception' );
is( $@->message, 'test exception' );
