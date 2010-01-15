#!perl

use strict;
use warnings;

use Test::More tests => 4;

{
    package TestRole;
    
    use strict;
    use Tsukumo::Role;
    
    __END_OF_ROLE__;
}

can_ok( 'TestRole', qw( meta ) );

ok( ! TestRole->can('has') );
ok( ! TestRole->can('__END_OF_ROLE__') );

{
    package TestRoleWithModule;
    
    use strict;
    use Tsukumo::Role 'X::AttributeHelpers';

    __END_OF_ROLE__;
}

my $class = ( Tsukumo::Utils::is_moosed() ) ? 'Moose' : 'Mouse' ;

ok( exists $INC{"${class}X/AttributeHelpers.pm"} );
