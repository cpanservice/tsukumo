package t::Util;

use strict;
use warnings;

use base qw( Exporter::Lite );

use Path::Class;
use FindBin ();

our ( $basedir );

our @EXPORT_OK = qw(
    $basedir
);

{
    my @path = dir($FindBin::Bin)->dir_list;
    while ( my $dir = pop @path ) {
        if ( $dir eq 't' ) {
            $basedir = dir(@path);
        }
    }
}

1;
