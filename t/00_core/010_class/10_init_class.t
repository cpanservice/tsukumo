#!perl

use strict;
use warnings;

use Tsukumo::Class;
use Test::More tests => 3;

can_ok( 'Tsukumo::Class', qw( init_class ) );

{
    package TestClass;
}

ok( Tsukumo::Class::init_class('TestClass') );

can_ok( 'TestClass', qw( meta ) );
