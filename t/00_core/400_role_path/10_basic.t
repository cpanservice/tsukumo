#!perl

use strict;
use warnings;

use Test::More tests => 4 * 5;

{
    package TestClass;
    
    use Tsukumo::Class;
    with 'Tsukumo::Role::Path';
    __END_OF_CLASS__;
}

my $file = TestClass->new( fullpath => '/foo.txt' );

is( $file->path, '/' );
is( $file->filename, 'foo' );
is( $file->file_extension, 'txt' );
is( $file->fullpath, '/foo.txt' );

$file = TestClass->new( fullpath => '/path/to/./file' );

is( $file->path, '/path/to' );
is( $file->filename, 'file' );
is( $file->file_extension, '' );
is( $file->fullpath, '/path/to/file' );

$file = TestClass->new( fullpath => 'path/to/' );

is( $file->path, '/path/to' );
is( $file->filename, '' );
is( $file->file_extension, '' );
is( $file->fullpath, '/path/to/' );

$file = TestClass->new( fullpath => 'path/to/file.txt' );

is( $file->path, '/path/to' );
is( $file->filename, 'file' );
is( $file->file_extension, 'txt' );
is( $file->fullpath, '/path/to/file.txt' );

$file = TestClass->new( fullpath => '/path/to/file.txt' );
$file->path('/path/to/./dir');
$file->filename('/filename');
$file->file_extension('html');

is( $file->path, '/path/to/dir' );
is( $file->filename, 'filename' );
is( $file->file_extension, 'html' );
is( $file->fullpath, '/path/to/dir/filename.html' );
