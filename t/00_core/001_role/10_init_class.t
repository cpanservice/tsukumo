#!perl

use strict;
use warnings;

use Tsukumo::Role;
use Test::More tests => 3;

can_ok( 'Tsukumo::Role', qw( init_role ) );

{
    package TestRole;
}

ok( Tsukumo::Role::init_role('TestRole') );

can_ok( 'TestRole', qw( meta ) );
