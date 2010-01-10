#!perl

use strict;
use warnings;

use Test::More tests => 3;
use Tsukumo::Exceptions qw( argument_parameter_missing );

local $@;
eval { argument_parameter_missing error => 'test exception', requires => [qw( foo bar )] };

isa_ok( $@, 'Tsukumo::Exception::ArgumentParameterMissing' );

is_deeply( $@->requires, [qw( foo bar )] );

is( $@->message, 'test exception' );
