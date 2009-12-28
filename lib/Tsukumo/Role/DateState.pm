package Tsukumo::Role::DateState;

use strict;
use Tsukumo::Role;
use Tsukumo::Types qw( Date );

requires qw( datestat );

has created => (
    is      => 'rw',
    isa     => Date,
    coerce  => 1,
    builder => '_build_created',
    clearer => 'clear_created',
    lazy    => 1,
);

has lastmodified => (
    is      => 'rw',
    isa     => Date,
    coerce  => 1,
    builder => '_build_lastmodified',
    clearer => 'clear_lastmodified',
    lazy    => 1,
);

sub _build_created      { return $_[0]->datestat->{'created'}       }
sub _build_lastmodified { return $_[0]->datestat->{'lastmodified'}  }

sub update_created      { $_[0]->clear_created;         $_[0]->created          }
sub update_lastmodified { $_[0]->clear_lastmodified;    $_[0]->lastmodified     }

__END_OF_ROLE__;

=head1 NAME

Tsukumo::Role::DateState - Date state role for Tsukumo.

=head1 SYNPOSIS

    package DateFolder;
    
    use strict;
    use Tsukumo::Class;
    
    with 'Tsukumo::Role::DateState';
    
    sub datestat { # Tsukumo::Role::DateState is required.
        return {
            created         => $time,
            lastmodified    => $time,
        }
    };
    
    __END_OF_CLASS__;
    
    package main;
    
    my $folder = DateFolder->new( created => $time );
    
    $folder->created;
    $folder->lastmodified;

=head1 DESCRIPTION

This role is datetime state role.

=head1 REQUEIREMENTS

=head2 C<datestat>

    sub datestat {
        return {
            created         => $datetime,
            lastmodified    => $datetime,
        }
    }

This request method has to return the hash reference including C<created> and C<lastmodified>.

When property C<created> and C<lastmodified> are built,
C<created> and C<lastmodified> of the hash reference are used.

Property C<created> and C<lastmodified> are coercion of C<Tsukumo::Types::Date>.

Please see C<Tsukumo::Types::Date> code.

=head1 PROPERTIES

=head2 C<created>

This property is returned L<Tsukumo::Class::Date> object of created time.

=head2 C<lastmodified>

This property is returned L<Tsukumo::Class::Date> object of last modified time.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Class::Date>, L<Tsukumo::Types>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
