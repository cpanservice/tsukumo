#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Tsukumo::Utils qw( any_moose );


$Tsukumo::Utils::is_moosed = 1;

is( any_moose(),                'Moose'                 );
is( any_moose('X::Types'),      'MooseX::Types'         );
is( any_moose('::Meta::Class'), 'Moose::Meta::Class'    );
is( any_moose('Mouse::Util'),   'Moose::Util'           );
is( any_moose('MouseX::Types'), 'MooseX::Types'         );

