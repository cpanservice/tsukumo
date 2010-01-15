#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Tsukumo::Format;

my $format = Tsukumo::Format->new( format => 'PlainText' );

is( $format->name, 'PlainText' );
is_deeply( $format->extensions, [qw( txt )] );

is( $format->parse('text'), 'text' );
is( $format->format('text'), 'text' );

my $var = [];
my $str = "${var}";

is( $format->format($var), $str );
