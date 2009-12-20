#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Class::Variables;

my $vars = Tsukumo::Class::Variables->new({
    foo => Encode::decode( 'utf8', 'bar' ),
});

ok( utf8::is_utf8($vars->{'foo'}) );

$vars->encode('utf8');

ok( ! utf8::is_utf8($vars->{'foo'}) );
