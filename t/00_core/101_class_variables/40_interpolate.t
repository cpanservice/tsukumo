#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Class::Variables;

my $vars = Tsukumo::Class::Variables->new({
    foo => '${foo}',
    bar => '${uc(bar)}',
});

$vars->interpolate(
    vars => {
        foo => 'AAA',
        uc  => sub { uc $_[2] },
    },
);

is( $vars->{'foo'}, 'AAA' );
is( $vars->{'bar'}, 'BAR' );
