#!perl

use strict;
use warnings;

use Test::More tests => 6;
use t::Util qw( $basedir );
use Tsukumo::Types::Resource qw( Perl );

my $path = $basedir->file('lib/Tsukumo.pm')->stringify;

is( Perl, 'Tsukumo::Types::Resource::Perl' );

ok( Perl->check( Tsukumo::Resource->new( source => 'File', format => 'Perl', fullpath => $path ) ) );
ok( ! Perl->check( Tsukumo::Resource->new( source => 'File', format => 'YAML', fullpath => $path ) ) );

isa_ok( Perl->coerce( $path ), 'Tsukumo::Resource::File' );
isa_ok( Perl->coerce([ fullpath => $path ]), 'Tsukumo::Resource::File' );
isa_ok( Perl->coerce({ fullpath => $path }), 'Tsukumo::Resource::File' );

