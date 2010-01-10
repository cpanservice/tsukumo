package Tsukumo::Role::File;

use strict;
use Tsukumo::Role;
use IO::File ();
use File::stat ();

use Tsukumo::Role::Path;
use Tsukumo::Role::DateState;
with qw( Tsukumo::Role::Path Tsukumo::Role::DateState );

sub open {
    my ( $self, @args ) = @_;
    return IO::File->new( $self->fullpath, @args );
}

sub openr {
    my ( $self, @args ) = @_;
    return $self->open('r', @args);
}

sub openw {
    my ( $self, @args ) = @_;
    return $self->open('w', @args);
}

sub slurp {
    my ( $self, %args ) = @_;
    my $fh = $self->openr;

    if ( $args{'chomped'} || $args{'chomp'} ) {
        chomp( my @data = <$fh> );
        return wantarray ? @data : join q{}, @data;
    }

    local $/ if ( ! wantarray );
    return <$fh>;
}

sub datestat {
    my ( $self ) = @_;

    my $stat = File::stat::stat($self->fullpath);
    my $time;
       $time = $stat->mtime if ( ref $stat );
       $time = time if ( ! defined $time );

    return {
        created         => $time,
        lastmodified    => $time,
    };
}

sub filestat {
    return File::stat::stat( $_[0]->fullpath );
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

=head1 METHODS

=head2 C<open>

    my $fh = $file->open( @IO_FILE_CONSTRUCTOR_ARGS );

This method retruns L<IO::Handle> object.

=head2 C<openr>

    my $fh = $file->openr; # same as $file->open('r', @args);

=head2 C<openw>

    my $fh = $file->openw; # same as $file->open('w', @args);

=head2 C<filestat>

This method retruns L<File::stat::stat> results.

=head2 C<datestat>

This method retruns datetime stat.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Role::Path>, L<Tsukumo::Role::DateState>,

L<Path::Class::File>,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
