#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Exceptions qw( invalid_argument_error );

local $@;
eval { invalid_argument_error error => 'foo'; };

isa_ok( $@, 'Tsukumo::Exception::InvalidArgumentError' );
is( $@->message, 'foo' );

