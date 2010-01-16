package Tsukumo::Role::File;

use strict;
use Tsukumo::Role;

use Coro::Handle ();
use IO::File;
use File::stat;

use Tsukumo::Role::Path;
use Tsukumo::Role::DateState;
with qw( Tsukumo::Role::Path Tsukumo::Role::DateState );

sub open {
    my ( $self, @args ) = @_;

    my $fh = IO::File->new( $self->fullpath, @args );
       $fh = Coro::Handle::unblock $fh;

    return $fh;
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

    my @data;
    while ( my $line = $fh->readline ) {
        push @data, $line;
    }

    if ( $args{'chomped'} || $args{'chomp'} ) {
        chomp @data;
    }

    return wantarray ? @data : join q{}, @data ;
}

sub datestat {
    my ( $self ) = @_;

    my $stat = $self->filestat;
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

This method retruns unblocking file handle.

See also L<Coro::Handle>.

=head2 C<openr>

    my $fh = $file->openr; # same as $file->open('r', @args);

=head2 C<openw>

    my $fh = $file->openw; # same as $file->open('w', @args);

=head2 C<slurp>

    my $data = $file->slurp;
    my $data = $file->slurp( chomp => 1 );
    
    my @data = $file->slurp;
    my @data = $file->slurp( chomped => 1 );

This method returns file content.

=head2 C<filestat>

This method retruns L<File::stat::stat> results.

=head2 C<datestat>

This method retruns datetime stat.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Role::Path>, L<Tsukumo::Role::DateState>,

L<Coro::Handle>,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
