#!perl

use strict;
use warnings;

use Test::More tests => 1;
use Tsukumo::Role::Formatter;

{
    package MyFormat;
    
    use Tsukumo::Class;
    with qw( Tsukumo::Role::Formatter );
    
    sub name { __PACKAGE__ }
    
    sub extensions {[qw( pl yaml )]}
    
    sub parse { return 1 }
    
    sub format { return 1 }
    
    __END_OF_CLASS__;
}

my $format = MyFormat->new;

can_ok( $format, qw( name extensions parse format ) );
