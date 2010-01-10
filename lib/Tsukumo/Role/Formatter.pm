package Tsukumo::Role::Formatter;

use strict;
use Tsukumo::Role;

requires qw( name extensions parse format );

__END_OF_ROLE__;

=head1 NAME

Tsukumo::Role::Formatter - Formatter role for Tsukumo.

=head1 SYNPOSIS

    package MyFormat;
    
    use strict;
    use Tsukumo::Class;
    
    with qw( Tsukumo::Role::Format );
    
    sub name        {'MyFormat'};
    sub extension   {[qw( mf myformat )]}
    
    sub parse {
        # parse code here
    }
    
    sub format {
        # format code here
    }
    
    __END_OF_CLASS__;

=head1 DESCRIPTION

This role is requirements of formatter interface.

=head1 REQUIREMENTS

=head2 C<name>

    sub name { 'Perl' }

This method returns formatter name.

The value of this method returns has to be scalar.

=head2 C<extensions>

    sub extensions { [qw( pl perl )] }

This method is returned file extensions for formatter support format.

The value of this method returns has to be ARRAY reference.

=head2 C<parse>

    sub parse {
        my ( $self, $source ) = @_;
        # parse code here
    }

This method is parser of support format.

=head1 C<format>

    sub format {
        my ( $self, $perlvar ) = @_;
        # format code here
    }

This method is formatter of support format.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
