#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Utils qw( is_moosed );

ok( ! is_moosed()  );

$Tsukumo::Utils::is_moosed = 1;

ok( is_moosed() );
