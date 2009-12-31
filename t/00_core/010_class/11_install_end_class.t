#!perl

use strict;
use warnings;

require Tsukumo::Class;
use Test::More tests => 2;

{
    package TestClass;
    1;
}

can_ok( 'Tsukumo::Class', qw( install_end_of_class ) );

Tsukumo::Class::install_end_of_class('TestClass');

can_ok('TestClass', qw( __END_OF_CLASS__ ));
