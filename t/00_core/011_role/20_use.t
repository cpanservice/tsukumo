#!perl

use strict;
use warnings;

use Test::More tests => 3;

{
    package TestRole;
    
    use strict;
    use Tsukumo::Role;
    
    __END_OF_ROLE__;
}

can_ok( 'TestRole', qw( meta __END_OF_ROLE__ ) );

ok( ! TestRole->can('has') );

{
    package TestRoleWithModule;
    
    use strict;
    use Tsukumo::Role 'X::AttributeHelpers';

    __END_OF_ROLE__;
}

my $class = ( Tsukumo::Utils::is_moosed() ) ? 'Moose' : 'Mouse' ;

ok( exists $INC{"${class}X/AttributeHelpers.pm"} );
