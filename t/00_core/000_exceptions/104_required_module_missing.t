#!perl

use strict;
use warnings;

use Test::More tests => 3;
use Tsukumo::Exceptions qw( required_module_missing );

local $@;
eval { required_module_missing error => 'test exception', requires => [qw( Plack Plack::Server::CGI )] };

isa_ok( $@, 'Tsukumo::Exception::RequiredModuleMissing' );

is_deeply( $@->requires, [qw( Plack Plack::Server::CGI )] );

is( $@->message, 'test exception' );
