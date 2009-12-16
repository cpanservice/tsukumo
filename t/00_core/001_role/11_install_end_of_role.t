#!perl

use strict;
use warnings;

require Tsukumo::Role;
use Test::More tests => 2;

{
    package TestRole;
    1;
}

can_ok( 'Tsukumo::Role', qw( install_end_of_role ) );

Tsukumo::Role::install_end_of_role('TestRole');

can_ok('TestRole', qw( __END_OF_ROLE__ ));
