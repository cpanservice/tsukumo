package Tsukumo::Class;

use strict;
use warnings;
use utf8;
use Any::Moose;
use Tsukumo::Exceptions;

sub init_class {
    my ( $target ) = @_;

    my $meta = any_moose('::Meta::Class')->initialize($target);
       $meta->superclasses(any_moose('::Object')) if ( ! $meta->superclasses );

    no strict 'refs';
    no warnings 'redefine';

    *{"${target}::meta"} = sub { $meta };

    return 1;
}

sub end_of_class {
    my ( $target, $unimport, @args ) = @_;
    my $class = any_moose;

    $target->meta->make_immutable( @args );

    my $eval = qq{ package ${target}; \n};
    for my $module ( @{ $unimport }  ) {
        $eval .= qq{ ${module}->unimport(); \n};
    }
       $eval .= qq{ ${class}->unimport(); };

    local $@;
    eval $eval;
    Tsukumo::Exception->throw( error => "Cannot umimport Tsukumo::Class: $@" )
        if ( $@ );

    return 1;
}

sub install_end_of_class {
    my ( $target, $unimport ) = @_;

    no strict 'refs';

    *{"${target}::__END_OF_CLASS__"} = sub {
        my $caller = caller(0);
        end_of_class($caller, $unimport, @_);
    };

}

sub import {
    my $class       = shift;
    my $caller      = caller(0);
    my @modules     = ();
    my @unimport    = ();

    while ( my $module = shift ) {
        my $args = ( @_ && ref($_[0]) ) ? shift : [] ;
        $module = any_moose($module);
        push @modules, ( $module => $args );
        push @unimport, $module;
    }

    install_end_of_class( $caller, \@unimport );

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

    while ( my ( $module, $args ) = splice @modules, 0, 2 ) {
        local $@;
        eval { Any::Moose::load_class($module) };
        Tsukumo::Exception->throw( error => "Cannot import Tsukumo::Class: $@" ) if ( $@ );

        eval  qq{package ${caller};\n}
            .  q{$module->import( @{ $args } )};
        Tsukumo::Exception->throw( error => "Cannot import Tsukumo::Class: $@" ) if ( $@ );
    }

    return;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Tsukumo::Class - Class builder for Tsukumo

=head1 SYNPOSIS

    package Foo;
    use strict;
    use Tsukumo::Class; # same use Any::Moose;
    
    has bar => (
        is => 'rw',
    );
    
    __END_OF_CLASS__ # same no Any::Moose;

=head1 DESCRIPTION

This class is class builder for Tsukumo.

This class uses L<Any::Moose> inside.

=head1 FUNCTIONS

=head2 C<init_class>

=head2 C<end_of_class>

=head2 C<install_end_of_class>

=head2 C<import>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
