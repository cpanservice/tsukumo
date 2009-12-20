#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Class::Variables;

my $vars = {
    foo => {
        bar => 'baz',
    },
};

my $obj = Tsukumo::Class::Variables->new($vars);

isa_ok( $obj, 'Tsukumo::Class::Variables' );
is_deeply( $obj, $vars );
