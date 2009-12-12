#!perl

use strict;
use warnings;

use Test::More tests => 2;

{
    package TestClass;
    
    use strict;
    use Tsukumo::Class;
    
    __END_OF_CLASS__
}

can_ok( 'TestClass', qw( meta __END_OF_CLASS__ ) );

ok( ! TestClass->can('has') );
