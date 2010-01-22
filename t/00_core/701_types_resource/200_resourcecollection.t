#!perl

use strict;
use warnings;

use t::Util qw( $basedir );
use Tsukumo::Types::Resource qw( ResourceCollection );
use Test::More;

my $type = ResourceCollection;

is( $type, 'Tsukumo::Types::Resource::ResourceCollection' );

ok( $type->check( [ Tsukumo::Resource->new( source => 'File', fullpath => $basedir->file('README') ) ] ));
ok( ! $type->check( [ {} ] ) );

my $res = Tsukumo::Resource->new( source => 'File', fullpath => $basedir->file('README') );

is_deeply(
    $type->coerce( { source => 'File', fullpath => $basedir->file('README') } ),
    [ $res ],
);

is_deeply(
    $type->coerce( $res ),
    [ $res ],
);

my @args = ( source => 'File', fullpath => $basedir->file('README') );

is_deeply(
    $type->coerce( [ { @args }, [ @args ] ] ),
    [ $res, $res ],
);

done_testing;
