package Tsukumo::Class;

use strict;
use warnings;
use utf8;
use Any::Moose;

sub init_class {
    my ( $target ) = @_;

    my $meta = any_moose('::Meta::Class')->initialize($target);

    no strict 'refs';
    no warnings 'redefine';

    *{"${target}::meta"} = sub { $meta };

    return 1;
}

sub end_of_class {
    my ( $target ) = @_;

    $target->meta->make_immutable( inline_destructor => 1  );
    eval "package ${target}; no Any::Moose;";

    return 1;
}

sub install_end_of_class {
    my ( $target ) = @_;

    no strict 'refs';

    *{"${target}::__END_OF_CLASS__"} = sub {
        my $caller = caller(0);
        end_of_class($caller);
    };

}

sub import {
    my $class = shift;
    my $caller = caller(0);

    install_end_of_class($caller);

    strict->import;
    warnings->import;
    utf8->import;

    init_class($caller);

    if ( Any::Moose::moose_is_preferred() ) {
        Moose->import({ into_level => 1 });
    }
    else {
        Mouse->export_to_level(1);
    }
}


1;
