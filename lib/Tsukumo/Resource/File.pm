package Tsukumo::Resource::File;

use strict;
use Tsukumo::Class;
use Tsukumo::Types::Formatter qw( Formatter );
use Tsukumo::Exceptions qw( file_io_error );

use Tsukumo::Role::File;
use Tsukumo::Role::Resource;
use Tsukumo::Role::Formatter;
use Tsukumo::Format::PlainText;

with qw( Tsukumo::Role::File Tsukumo::Role::Resource );

has formatter => (
    is          => 'ro',
    isa         => Formatter,
    does        => 'Tsukumo::Role::Formatter',
    coerce      => 1,
    required    => 1,
    init_arg    => 'format',
    lazy        => 1,
    builder     => '_build_formatter',
);

sub _build_formatter { Tsukumo::Format::PlainText->new }

sub type { 'File' }

sub load {
    my ( $self ) = @_;
    my $data = $self->slurp;
    return $self->formatter->parse( $data );
}

sub write {
    my ( $self ) = @_;
    my $source = $self->formatter->format( $self->data );

    my $fh = $self->openw;
       $fh->print( $source )
            or file_io_error( error => "Cannot write data: " . $self->fullpath, path => $self->fullpath, action => 'print' );
       $fh->close
            or file_io_error( error => "Cannot close handle: " . $self->fullpath, path => $self->fullpath, action => 'close' );

    return 1;
}

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Resource::File - File resource class for Tsukumo.

=head1 SYNPOSIS

    use Tsukumo::Resource::File;
    
    my $file = Tsukumo::Resource::File->new(
        format      => 'Perl',
        fullpath    => '/path/to/config.pl',
    );
    
    require Data::Dumper;
    Data::Dumper::Dumper( $file->data );

=head1 DESCRIPTION

This class is file resource class for Tsukumo.

This class mixined L<Tsukumo::Role::File> and L<Tsukumo::Role::Resource>.

=head1 METHODS

=head2 C<new>

    my $file = Tsukumo::Resource::File->new(
        format      => 'Perl',
        fullpath    => '/path/to/perl.pl',
    );

This method is constructor of Tsukumo::Resource::File.

B<Required arguments:>

=over

=item C<format>

The format of the file specifies as this argument.

=item C<fullpath>

A full file path specified as this argument.

=back

=head2 C<open>

This method open file.

=head2 C<openr>

    $file->openr; # same as $file->open('r');

=head2 C<openw>

    $file->openw; # same as $file->open('w');

=head2 C<slurp>

    my $data = $file->slurp;
    my @data = $file->slurp;

This method returns file content.

=head2 C<update_created>

This method updates C<created> property.

=head2 C<update_lastmodified>

This method updates C<lastmodified> property.

=head2 C<write>

This method writes data in a file.

=head1 PROPERTIES

=head2 C<type>

This property returns C<'File'>.

=head2 C<data>

This property returns file data.

=head2 C<fullpath>

This property returns full file path.

This property is provided by L<Tsukumo::Role::Path>.

=head2 C<path>

This property returns parent directory path.

This property is provided by L<Tsukumo::Role::Path>.

=head2 C<filename>

This property returns file name.

This property is provided by L<Tsukumo::Role::Path>.

=head2 C<file_extension>

This property returns file extension.

This property is provided by L<Tsukumo::Role::Path>.

=head2 C<created>

This property returns L<Tsukumo::Class::Date> object of created time.

This property is provided by L<Tsukumo::Role::DateState>.

=head2 C<lastmodified>

This property returns L<Tsukumo::Class::Date> object of lastmodified time.

This property is provided by L<Tsukumo::Role::DateState>.

=head2 C<filestat>

This property returns file state object.

This method is provided by L<Tsukumo::Role::File>.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Resource>

L<Tsukumo::Role::Path>, L<Tsukumo::Resource::DateState>, L<Tsukumo::Role::File>, L<Tsukumo::Role::Resource>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
