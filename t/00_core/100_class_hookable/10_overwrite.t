#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Class::Hookable;

my $hook = Tsukumo::Class::Hookable->new;

isa_ok( $hook->class_hookable_stash, 'HASH' );
is( $hook->class_hookable_filter_prefix, 'filter' );
