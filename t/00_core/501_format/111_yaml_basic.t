#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Tsukumo::Format;

my $yaml = Tsukumo::Format->new(
    format          => 'YAML',
    implementaion   => 'YAML',
);

is( $yaml->name, 'YAML' );
is_deeply( $yaml->extensions, [qw( yml yaml )] );

my $code = <<'__YAML__';
---
bar:
- BBB
- CCC
foo: AAA
__YAML__

my $struct = $yaml->parse($code);

is_deeply(
    $struct,
    {
        foo => 'AAA',
        bar => [qw( BBB CCC )],
    },
);

is(
    $yaml->format( $struct ),
    $code,
);