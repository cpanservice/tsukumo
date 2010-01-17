#!perl

use strict;
use warnings;

use Test::More tests => 6;
use t::Util qw( $basedir );
use Tsukumo::Types::Resource qw( YAML );

my $path = $basedir->file('README')->stringify;

is( YAML, 'Tsukumo::Types::Resource::YAML' );

ok( YAML->check( Tsukumo::Resource->new( source => 'File', format => 'YAML', fullpath => $path ) ) );
ok( ! YAML->check( Tsukumo::Resource->new( source => 'File', format => 'Perl', fullpath => $path ) ) );

isa_ok( YAML->coerce( $path ), 'Tsukumo::Resource::File' );
isa_ok( YAML->coerce([ fullpath => $path ]), 'Tsukumo::Resource::File' );
isa_ok( YAML->coerce({ fullpath => $path }), 'Tsukumo::Resource::File' );

