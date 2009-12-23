#!perl

use strict;
use warnings;

use Tsukumo::Types qw( FilePath FileName FileExtension );
use Test::More tests => 3 + 6 + 4;

is( FilePath,       'Tsukumo::Types::FilePath' );
is( FileName,       'Tsukumo::Types::FileName' );
is( FileExtension,  'Tsukumo::Types::FileExtension' );

ok( FilePath->check('/path/to/file.txt') );
ok( ! FilePath->check('path/to/./file.txt') );

ok( FileName->check('filename') );
ok( ! FileName->check('/filename') );

ok( FileExtension->check('txt') );
ok( ! FileExtension->check('.txt') );

is( FilePath->coerce('./path/to/./file.txt'), '/path/to/file.txt' );
is( FilePath->coerce([qw( foo bar baz )]), '/foo/bar/baz' );

is( FileName->coerce('/filename'), 'filename' );

is( FileExtension->coerce('.txt'), 'txt' );
