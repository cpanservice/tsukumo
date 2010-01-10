#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Exceptions qw( evaluate_code_failed );

local $@;
eval { evaluate_code_failed error => 'error!' };

isa_ok( $@, 'Tsukumo::Exception::EvaluateCodeFailed' );
is( $@->message, 'error!' );
