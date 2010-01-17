#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Tsukumo::Types::Resource qw( Resource );
use t::Util qw( $basedir );

is( Resource, 'Tsukumo::Types::Resource::Resource' );

my %args = (
    source      => 'File',
    format      => 'Perl',
    fullpath    => $basedir->file('lib/Tsukumo.pm')->stringify,
);

ok( Resource->check( Tsukumo::Resource->new( %args ) ) );
ok( ! Resource->check({}) );

isa_ok( Resource->coerce([ %args ]), 'Tsukumo::Resource::File' );
isa_ok( Resource->coerce({ %args }), 'Tsukumo::Resource::File' );
