#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Tsukumo::Utils qw( any_moose );

is( any_moose(),                'Mouse'                 );
is( any_moose('X::Types'),      'MouseX::Types'         );
is( any_moose('::Meta::Class'), 'Mouse::Meta::Class'    );
is( any_moose('Moose::Util'),   'Mouse::Util'           );

