#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Tsukumo::Exceptions qw( file_io_error );

local $@;
eval { file_io_error error => 'test exception', path => '/path/to/file.txt', action => 'open' };

isa_ok( $@, 'Tsukumo::Exception::FileIOError' );
is( $@->path, '/path/to/file.txt' );
is( $@->action, 'open' );
is( $@->message, 'test exception' );
