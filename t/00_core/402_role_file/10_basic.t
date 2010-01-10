#!perl

use strict;
use warnings;

use Test::More tests => 8;
use t::Util qw( $basedir $examples );
use Tsukumo::Class::Date;
use File::Temp qw( tempfile );

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

my $date = $pm->stat->mtime;

is_deeply( $file->created->epoch,      $date );
is_deeply( $file->lastmodified->epoch, $date );

is_deeply(
    $file->filestat,
    $pm->stat,
);

$file = MyFile->new( fullpath => $examples->file('core/role_file/foo.txt')->stringify );

is( $file->slurp, 'foo' );
