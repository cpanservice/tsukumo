#!perl

use strict;
use warnings;

use Test::More tests => 2;

{
    package TestRole;
    
    use strict;
    use Tsukumo::Role;
    
    __END_OF_ROLE__;
}

can_ok( 'TestRole', qw( meta __END_OF_ROLE__ ) );

ok( ! TestRole->can('has') );
