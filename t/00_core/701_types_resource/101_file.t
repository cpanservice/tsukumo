#!perl

use strict;
use warnings;

use Test::More tests => 6;
use t::Util qw( $basedir );
use Tsukumo::Types::Resource qw( File );

my $path = $basedir->file('README')->stringify;

is( File, 'Tsukumo::Types::Resource::File' );

ok( File->check( Tsukumo::Resource->new( source => 'File', format => 'PlainText', fullpath => $path ) ) );
ok( ! File->check( {} ) );

isa_ok( File->coerce( $path ), 'Tsukumo::Resource::File' );
isa_ok( File->coerce([ fullpath => $path ]), 'Tsukumo::Resource::File' );
isa_ok( File->coerce({ fullpath => $path }), 'Tsukumo::Resource::File' );

