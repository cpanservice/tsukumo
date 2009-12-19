#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Exceptions;

local $@;
eval { Tsukumo::Exception::InvalidArgumentError->throw( error => 'foo' ) };

isa_ok( $@, 'Tsukumo::Exception::InvalidArgumentError' );
is( $@->message, 'foo' );

