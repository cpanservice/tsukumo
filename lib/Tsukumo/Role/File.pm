package Tsukumo::Role::File;

use strict;
use Tsukumo::Role;
use Tsukumo::Role (
    'X::Types::Path::Class' => [qw( File )],
);
use Path::Class::File;
use Tsukumo::Role::Path;
use Tsukumo::Role::DateState;

with qw( Tsukumo::Role::Path Tsukumo::Role::DateState );

has file => (
    is      => 'ro',
    isa     => File,
    coerce  => 1,
    lazy    => 1,
    clearer => 'clear_file',
    builder => 'setup_file',
);

sub setup_file { $_[0]->fullpath }

sub datestat {
    my ( $self ) = @_;

    my $stat = $self->file->stat;
    my $time;
       $time = $stat->mtime;
       $time = time if ( ! defined $time );

    return {
        created         => $time,
        lastmodified    => $time,
    };
}

__END_OF_ROLE__;

=head1 NAME

Tsukumo::Role::File - File role for Tsukumo.

=head1 SYNPOSIS

    package MyFile;
    
    use strict;
    use Tsukumo::Class;
    
    with qw( Tsukumo::Role::File );
    
    __END_OF_CLASS__;

=head1 DESCRIPTION

This role is File role for Tsukumo.

This role mixes with L<Tsukumo::Role::Path> and L<Tsukumo::Role::DateState>.

=head1 REQUIREMENTS

none

=head1 PROPERTIES

=head2 C<file>

This property retruns L<Path::Class::File> object.

=head1 METHODS

=head2 C<setup_file>

=head2 C<datestat>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Role::Path>, L<Tsukumo::Role::DateState>,

L<Path::Class::File>,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
