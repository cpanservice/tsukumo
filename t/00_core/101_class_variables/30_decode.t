#!perl

use strict;
use warnings;

use Test::More tests => 1;
use Tsukumo::Class::Variables;

my $vars = Tsukumo::Class::Variables->new({
    foo => 'bar',
});

$vars->decode('utf8');

ok( utf8::is_utf8($vars->{'foo'}) );
