package Tsukumo::Role;

use strict;
use warnings;

use Tsukumo::Utils ();

my $metaclass;
my $roleclass;

BEGIN {
    $metaclass = Tsukumo::Utils::any_moose('::Meta::Role');
    $roleclass = Tsukumo::Utils::any_moose('::Role');

    my $module = $roleclass;
       $module =~ s{::}{/}g;
       $module = "${module}.pm";
    require $module;
}

sub init_role {
    my ( $target ) = @_;

    my $meta = $metaclass->initialize($target);

    no strict 'refs';
    no warnings 'redefine';

    *{"${target}::meta"} = sub { $meta };
}

sub end_of_role {
    my ( $target, $unimport, @args ) = @_;

    my $eval = qq{package ${target};\n};
    for my $module ( @{ $unimport } ) {
        $eval .= qq{ ${module}->unimport(); \n};
    }
      $eval .= qq{${roleclass}->unimport};

    local $@;
    eval $eval;
    Tsukumo::Exception->throw( error => "Cannot unimport Tsukumo::Role: ${@}" )
        if ( $@ );

    return 1;
}

sub install_end_of_role {
    my ( $target, $unimport ) = @_;

    no strict 'refs';
    no warnings 'redefine';
    *{"${target}::__END_OF_ROLE__"} = sub {
        my $caller = caller(0);
        end_of_role($caller, $unimport, @_);
        uninstall_end_of_role($target);
    };
}

sub uninstall_end_of_role {
    my ( $target ) = @_;

    no strict 'refs';
    delete ${"${target}::"}{'__END_OF_ROLE__'};
}


sub import {
    my $class       = shift;
    my $caller      = caller(0);
    my @modules     = ();
    my @unimport    = ();

    while ( my $module = shift @_ ) {
        my $args = @_ && ref($_[0]) ? shift : [];
        $module = Tsukumo::Utils::any_moose($module);
        push @modules, ( $module, $args );
        push @unimport, $module;
    }

    install_end_of_role($caller, \@unimport);

    strict->import;
    warnings->import;

    init_role($caller);

    if ( Tsukumo::Utils::is_moosed ) {
        Moose::Role->import({ into_level => 1 });
    }
    else {
        Mouse::Role->export_to_level(1);
    }

    while ( my ( $module, $args ) = splice @modules, 0, 2 ) {
        local $@;
        eval { Tsukumo::Utils::load_class($module) };
        Tsukumo::Exception->throw( error => "Cannot import Tsukumo::Role: ${@}" ) if ( $@ );

        eval qq{package ${caller};\n}
            . q{$module->import( @{ $args } )};
        Tsukumo::Exception->throw( error => "Cannot import Tsukumo::Role: ${@}" ) if ( $@ );
    }

    return;
}

1;
__END__

=head1 NAME

Tsukumo::Role - Role builder for Tsukumo

=head1 SYNPOSIS

    package MyRole;
    
    use strict;
    use Tsukumo::Role;
    
    requires 'foo';
    
    __END_OF_ROLE__;

=head1 DESCRIPTION

This class is role builder for Tsukumo.

=head1 FUNCTIONS

=head2 C<init_role>

=head2 C<end_of_role>

=head2 C<install_end_of_role>

=head2 C<import>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
