#!perl

use strict;
use warnings;

use Tsukumo::Utils qw( rel2abs );
use Test::More tests => 2;

is( rel2abs('/path/to/././file'), '/path/to/file' );
is( rel2abs('path/./to/./file'), '/path/to/file' );
