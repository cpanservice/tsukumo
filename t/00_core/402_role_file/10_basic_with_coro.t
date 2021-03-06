#!perl

use strict;
use warnings;

use Coro;

use Test::More tests => 11;
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

my $root    = "${basedir}";
my $pm      = "${root}/lib/Tsukumo.pm";

my $file = MyFile->new( fullpath => $pm );

is( $file->path, "${root}/lib" );
is( $file->filename, 'Tsukumo' );
is( $file->file_extension, 'pm' );
is( $file->fullpath, $pm );

my $stat = File::stat::stat( $pm );
my $date = $stat->mtime;

is_deeply( $file->created->epoch,      $date );
is_deeply( $file->lastmodified->epoch, $date );

is_deeply(
    $file->filestat,
    $stat,
);

$file = MyFile->new( fullpath => "${examples}/core/role_file/foo.txt" );

my $fh = $file->openr;
isa_ok( $fh, 'Coro::Handle' );
$fh->close;

my $data = $file->slurp;
my @data = $file->slurp( chomp => 1 );

is( $data, <<'__FILE__');
foo
bar
baz
__FILE__

is_deeply( [ @data ], [qw( foo bar baz )] );

my @jobs = ();
my @num  = ();

push @jobs, async { push @num, 1; my @content = $file->slurp; push @num, 2 };
push @jobs, async { push @num, 3; my $content = $file->slurp; push @num, 4 };

$_->join for @jobs;

is_deeply(
    [ @num ],
    [ 1, 3, 2, 4 ],
);
