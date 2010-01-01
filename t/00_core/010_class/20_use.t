#!perl

use strict;
use warnings;

use Test::More tests => 3;

{
    package TestClass;
    
    use strict;
    use Tsukumo::Class;
    
    __END_OF_CLASS__;
}

can_ok( 'TestClass', qw( meta __END_OF_CLASS__ ) );

ok( ! TestClass->can('has') );

{
    package TestTypes;
    
    use strict;
    use Tsukumo::Class (
        'X::Types' => [ -declare => [qw( Foo )] ],
    );
    __END_OF_CLASS__;
}

my $class = ( Any::Moose::moose_is_preferred() ) ? 'Moose' : 'Mouse' ;

isa_ok( 'TestTypes', "${class}X::Types::Base" );
