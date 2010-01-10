#!perl

use strict;
use warnings;

use Test::More tests => 6;
use Tsukumo::Format;

my $format = Tsukumo::Format->new( format => 'Perl' );

is( $format->name, 'Perl' );
is_deeply( $format->extensions, [qw( pl perl )] );

is(
    $format->parse(q{ return 'foo' }),
    'foo',
);

ok( my $source = $format->format(sub { return 'bar' }) );
ok( my $code   = eval $source );
is( $code->(), 'bar' );

