#!perl

use strict;
use warnings;

use Test::More tests => 7;
use t::Util qw( $basedir );
use Path::Class::File;
use Tsukumo::Class::Date;

{
    package MyFile;
    
    use strict;
    use Tsukumo::Class;
    with qw( Tsukumo::Role::File );
    
    __END_OF_CLASS__;
}

my $pm  = $basedir->file('lib/Tsukumo.pm');

my $file = MyFile->new( fullpath => $pm->stringify );

is( $file->path, $pm->parent->stringify );
is( $file->filename, 'Tsukumo' );
is( $file->file_extension, 'pm' );
is( $file->fullpath, $pm->stringify );

isa_ok( $file->file, 'Path::Class::File' );

my $date = $file->file->stat->mtime;

is_deeply( $file->created->epoch,      $date );
is_deeply( $file->lastmodified->epoch, $date );
