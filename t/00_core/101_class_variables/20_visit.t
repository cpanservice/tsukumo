#!perl

use strict;
use warnings;

use Test::More tests => 1;
use Tsukumo::Class::Variables;

my $vars = Tsukumo::Class::Variables->new({
    foo => 'bar',
    bar => {
        baz => [qw( AAA BBB )],
        foo => {
            bar => 'baz',
            baz => [qw( CCC DDD )],
        },
    },
});

$vars->visit(sub { 'WWW' });

is_deeply(
    $vars,
    {
        foo => 'WWW',
        bar => {
            baz => [qw( WWW WWW )],
            foo => {
                bar => 'WWW',
                baz => [qw( WWW WWW )],
            },
        },
    },
);
