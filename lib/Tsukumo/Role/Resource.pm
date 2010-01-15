package Tsukumo::Role::Resource;

use strict;
use Tsukumo::Role;
use Tsukumo::Types::Builtin qw( Any );
use Tsukumo::Role::DateState;

with qw( Tsukumo::Role::DateState );
requires qw( load write type );

has data => (
    is      => 'rw',
    isa     => Any,
    lazy    => 1,
    clearer => 'clear',
    builder => 'load',
);

sub reload {
    my ( $self ) = @_;
    $self->data( $self->load );
}

__END_OF_ROLE__;

=head1 NAME

Tsukumo::Role::Resource - Resource role for Tsukumo.

=head1 SYNPOSIS

    package MyResource;
    
    use strict;
    use Tsukumo::Class;
    
    with qw( Tsukumo::Role::Resource );
    
    has '+data' => (
        isa => 'HashRef',
    );
    
    sub load {
        # load code here
    }
    
    sub write {
        # write code here
    }
    
    sub datestat {
        return {
            created         => $time,
            lastmodified    => $time,
        }
    }
    
    __END_OF_CLASS__;

=head1 DESCRIPTION

This role is resource role.

This role mixed L<Tsukumo::Role::DateState>.

=head1 REQUIREMENTS

=head2 C<load>

This method is builder method for C<data>.

=head2 C<reload>

This method reloads resource data.

=head2 C<write>

This method is write to resource source.

=head2 C<type>

This method returns resource type.

=head2 C<datestat>

This method is required by L<Tsukumo::Role::DateState>.

See L<Tsukumo::Role::DataState> document.

=head1 PROPERTIES

=head2 C<data>

This property is accessor of resource data.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

