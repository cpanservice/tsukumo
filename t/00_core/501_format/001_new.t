#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Tsukumo::Format;

{
    package Tsukumo::Format::Test;
    use Tsukumo::Class;
    __END_OF_CLASS__;
}

# first time
my $format = Tsukumo::Format->new( format => 'Test', foo => 'bar' );

isa_ok( $format, 'Tsukumo::Format::Test' );

# hit cache
my $format2 = Tsukumo::Format->new( format => 'Test', foo => 'bar' );

is( $format, $format2 );

# different arguments

my $format3 = Tsukumo::Format->new( format => 'Test', bar => 'baz' );

isnt( $format, $format3 );

# +My::Fomrat::Name

my $format4 = Tsukumo::Format->new( format => '+Tsukumo::Format::Test', bar => 'baz' );

is( $format3, $format4 );
