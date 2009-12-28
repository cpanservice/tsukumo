#!perl

use strict;
use warnings;

use Tsukumo::Types::Builtin qw( Str );
use Test::More tests => 1;

isa_ok( Str, Any::Moose::any_moose() . '::Meta::TypeConstraint' );
