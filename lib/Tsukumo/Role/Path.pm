package Tsukumo::Role::Path;

use Tsukumo::Role;
use Tsukumo::Types::Path qw( FilePath FileName FileExtension );

use File::Spec::Unix;

has path => (
    is          => 'rw',
    isa         => FilePath,
    coerce      => 1,
    lazy        => 1,
    builder     => '_build_path',
    clearer     => 'clear_path',
    init_arg    => undef,
    trigger     => sub { $_[0]->clear_fullpath },
);

has filename => (
    is          => 'rw',
    isa         => FileName,
    coerce      => 1,
    lazy        => 1,
    builder     => '_build_filename',
    clearer     => 'clear_filename',
    init_arg    => undef,
    trigger     => sub { $_[0]->clear_fullpath },
);

has file_extension => (
    is          => 'rw',
    isa         => FileExtension,
    coerce      => 1,
    lazy        => 1,
    builder     => '_build_file_extension',
    clearer     => 'clear_file_extension',
    init_arg    => undef,
    trigger     => sub { $_[0]->clear_fullpath },
);

sub _build_path {
    my ( $self ) = @_;
    return ( $self->splitfullpath )[0]
}

sub _build_filename {
    my ( $self ) = @_;
    return ( $self->splitfullpath )[1];
}

sub _build_file_extension {
    my ( $self ) = @_;
    return ( $self->splitfullpath )[2];
}

has fullpath => (
    is          => 'rw',
    isa         => FilePath,
    coerce      => 1,
    required    => 1,
    lazy        => 1,
    clearer     => 'clear_fullpath',
    builder     => '_build_fullpath',
    trigger     => sub {
        my ( $self ) = @_;
        $self->clear_path;
        $self->clear_filename;
        $self->clear_file_extension;
    },
);

sub _build_fullpath {
    my ( $self ) = @_;

    my $path            = $self->path;
    my $filename        = $self->filename;
    my $file_extension  = $self->file_extension;

    $filename       &&= "/${filename}";
    $file_extension &&= ".${file_extension}";

    return "${path}${filename}${file_extension}";
}

sub splitfullpath {
    my ( $self ) = @_;
    my $fullpath = $self->fullpath;
    my ( $path, $filename, $file_extension );

    if ( $fullpath =~ m{/$} ) {
        $path = $fullpath;
    }
    elsif ( $fullpath =~ m{^(?:(.*/))?(.+)$} ) {
        $path       = $1;
        $filename   = $2;
    }

    if ( $filename && $filename =~ m{^(.+)\.([^.]+)$} ) {
        $filename       = $1;
        $file_extension = $2;
    }

    $path           = q{} if ( ! defined $path );
    $filename       = q{} if ( ! defined $filename );
    $file_extension = q{} if ( ! defined $file_extension );

    $path           =~ s{/*$}{} if ( $path ne q{/} );

    return ( $path, $filename, $file_extension );
}

__END_OF_ROLE__;

=head1 NAME

Tsukumo::Role::Path - Basic path properties role for Tsukumo.

=head1 SYNPOSIS

    package FileClass;
    
    use strict;
    use Tsukumo::Class;
    
    with 'Tsukumo::Role::Path';

    __END_OF_CLASS__;
    
    package main;
    
    my $file = FileClass->new( fullpath => '/path/to/file.txt' );
       $file->path;
       $file->filename;
       $file->file_extension;
       $file->fullpath;

=head1 DESCRIPTION

This role is file path role for Tsukumo.

=head1 PROPERTIES

=head2 C<fullpath>

=head2 C<path>

=head2 C<filename>

=head2 C<file_extension>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
