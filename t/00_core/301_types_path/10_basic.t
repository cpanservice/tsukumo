#!perl

use strict;
use warnings;

use Test::More;
use Tsukumo::Types::Path qw( FilePath FileName FileExtension );

{
    package MyObject;
    
    use overload (
        q{""}       => sub { 'foo' },
        fallback    => 1,
    );
    
    sub new { bless {}, shift }
}

is( FilePath,       'Tsukumo::Types::Path::FilePath' );
is( FileName,       'Tsukumo::Types::Path::FileName' );
is( FileExtension,  'Tsukumo::Types::Path::FileExtension' );

ok( FilePath->check('/path/to/file.txt') );
ok( ! FilePath->check('path/to/./file.txt') );

ok( FileName->check('filename') );
ok( ! FileName->check('/filename') );

ok( FileExtension->check('txt') );
ok( ! FileExtension->check('.txt') );

is( FilePath->coerce('./path/to/./file.txt'), '/path/to/file.txt' );
is( FilePath->coerce([qw( foo bar baz )]), '/foo/bar/baz' );
is( FilePath->coerce( MyObject->new ), '/foo' );

is( FileName->coerce('/filename'), 'filename' );
is( FileName->coerce( MyObject->new ), 'foo' );

is( FileExtension->coerce('.txt'), 'txt' );
is( FileExtension->coerce( MyObject->new ), 'foo' );

done_testing;

