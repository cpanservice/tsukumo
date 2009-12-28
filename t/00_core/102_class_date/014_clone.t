#!perl

use strict;
use warnings;

use Tsukumo::Class::Date;
use Test::More tests => 2;

my $time = time;

my $date = gmtime($time);
my $clone = $date->clone;

is_deeply(
    $date,
    $clone,
);

$clone = $date->clone( offset => 9 * 60 * 60 );

is(
    $clone->epoch,
    $date->epoch + 9 * 60 * 60,
);
