package Tsukumo::Role;

use strict;
use warnings;
use utf8;
use Any::Moose;

BEGIN { eval qq{ require @{[ any_moose('::Role') ]} }; }

sub init_role {
    my ( $target ) = @_;

    my $meta = any_moose('::Meta::Role')->initialize($target);

    no strict 'refs';
    no warnings 'redefine';

    *{"${target}::meta"} = sub { $meta };
}

sub end_of_role {
    my ( $target ) = @_;

    my $class = any_moose('::Role');

    eval qq{package ${target}; ${class}->unimport()};

}

sub install_end_of_role {
    my ( $target ) = @_;

    no strict 'refs';
    *{"${target}::__END_OF_ROLE__"} = sub {
        my $caller = caller(0);
        end_of_role($caller);
    };
}


sub import {
    my $class   = shift;
    my $caller  = caller(0);

    install_end_of_role($caller);

    strict->import;
    warnings->import;
    utf8->import;

    init_role($caller);

    

    if ( Any::Moose::moose_is_preferred() ) {
        Moose::Role->import({ into_level => 1 });
    }
    else {
        Mouse::Role->export_to_level(1);
    }
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
1;


