#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Class::Variables;

my $vars = Tsukumo::Class::Variables->new({
    foo => 'bar',
    bar => {
        baz => 'AAA',
    },
});

$vars->merge(
    {
        baz => 'CCC',
    },
    {
        bar => { foo => 'BBB' },
    },
);

isa_ok( $vars, 'Tsukumo::Class::Variables' );

is_deeply(
    $vars,
    {
        foo => 'bar',
        bar => {
            foo => 'BBB',
            baz => 'AAA',
        },
        baz => 'CCC',
    },
);
