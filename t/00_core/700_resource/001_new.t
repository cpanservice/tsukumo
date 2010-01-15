#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Resource;

{
    package Tsukumo::Resource::Test;
    
    use strict;
    use Tsukumo::Class;
    
    has foo => (
        is => 'rw',
    );
    
    __END_OF_CLASS__;
}

my $res = Tsukumo::Resource->new( source => 'Test', foo => 'bar' );

isa_ok( $res, 'Tsukumo::Resource::Test' );

is( $res->foo, 'bar' );
