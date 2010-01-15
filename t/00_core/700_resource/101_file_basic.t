#!perl

use strict;
use warnings;

use Test::More tests => 4;
use t::Util qw( $examples );
use Tsukumo::Resource;
use File::Temp qw( tempfile );

my $res = Tsukumo::Resource->new(
    source      => 'File',
    format      => 'Perl',
    fullpath    => $examples->file('core/resource/file/foo.txt')->stringify,
);

is( $res->type, 'File' );

my $data = $res->data;

is_deeply(
    $data,
    {
        foo => 'bar',
    },
);

$res->fullpath( (tempfile)[1] );

$res->write();

ok( -e $res->fullpath );

$data = eval $res->slurp;

is_deeply(
    $data,
    {
        foo => 'bar',
    }
);