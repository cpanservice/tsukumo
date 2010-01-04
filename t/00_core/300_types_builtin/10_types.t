#!perl

use strict;
use warnings;

use Tsukumo::Types::Builtin qw( Str );
use Test::More tests => 1;

isa_ok( Str, Tsukumo::Utils::any_moose() . '::Meta::TypeConstraint' );
