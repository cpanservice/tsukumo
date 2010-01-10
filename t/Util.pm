package t::Util;

use strict;
use warnings;

use base qw( Exporter::Lite );

use Path::Class;
use FindBin ();

our ( $basedir, $examples );

our @EXPORT_OK = qw(
    $basedir $examples tempdir
);

{
    my @path = dir($FindBin::Bin)->dir_list;
    while ( my $dir = pop @path ) {
        if ( $dir eq 't' ) {
            $basedir    = dir(@path);
            $examples   = $basedir->subdir('t/examples'),
        }
    }
}

1;
