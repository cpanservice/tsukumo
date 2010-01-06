#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Role::DateState;

our $time = time;

{
    package DateFolder;
    
    use strict;
    use Tsukumo::Class;
    
    with 'Tsukumo::Role::DateState';
    
    sub datestat {
        return {
            created         => $main::time,
            lastmodified    => $main::time,
        };
    }
    
    __END_OF_CLASS__;
}

my $folder = DateFolder->new;

isa_ok( $folder->created,       'Tsukumo::Class::Date' );
isa_ok( $folder->lastmodified,  'Tsukumo::Class::Date' );
