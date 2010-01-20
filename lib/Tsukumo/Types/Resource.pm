package Tsukumo::Types::Resource;

use Tsukumo::Class 'X::Types' => [ -declare => [qw(
    Resource File YAML Perl
)] ];
use Tsukumo::Types::Builtin qw( ArrayRef HashRef Str );
use Tsukumo::Role::Resource;
use Tsukumo::Resource;

subtype Resource,
    as 'Tsukumo::Role::Resource',
;

coerce Resource,
    from ArrayRef,
        via { Tsukumo::Resource->new( @{ $_ } ) },
    from HashRef,
        via { Tsukumo::Resource->new( %{ $_ } ) },
;

subtype File,
    as 'Tsukumo::Role::Resource',
    where { $_->can('type') && $_->type eq 'File' }
;

coerce File,
    from Str,
        via { Tsukumo::Resource->new( source => 'File', format => 'PlainText', fullpath => $_ ) },
    from ArrayRef,
        via { Tsukumo::Resource->new( @{ $_ }, source => 'File' ) },
    from HashRef,
        via { Tsukumo::Resource->new( %{ $_ }, source => 'File' ) },
;

subtype YAML,
    as 'Tsukumo::Role::Resource',
    where { $_->can('formatter') && ref $_->formatter && $_->formatter->name eq 'YAML' },
    message { "Resource format is not YAML" },
;

coerce YAML,
    from Str,
        via { Tsukumo::Resource->new( source => 'File', format => 'YAML', fullpath => $_ ) },
    from ArrayRef,
        via { Tsukumo::Resource->new( @{ $_ }, source => 'File', format => 'YAML' ) },
    from HashRef,
        via { Tsukumo::Resource->new( %{ $_ }, source => 'File', format => 'YAML' ) },
;

subtype Perl,
    as 'Tsukumo::Role::Resource',
    where { $_->can('formatter') && ref $_->formatter && $_->formatter->name eq 'Perl' },
    message { "Resource format is not Perl" },
;

coerce Perl,
    from Str,
        via { Tsukumo::Resource->new( source => 'File', format => 'Perl', fullpath => $_ ) },
    from ArrayRef,
        via { Tsukumo::Resource->new( @{ $_ }, source => 'File', format => 'Perl' ) },
    from HashRef,
        via { Tsukumo::Resource->new( %{ $_ }, source => 'File', format => 'Perl' ) },
;

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Types::Resource - (Moose|Mouse) types for Tsukumo resources.

=head1 SYNPOSIS

    package MyClass;
    
    use strict;
    use Tsukumo::Class;
    use Tsukumo::Types::Resource qw( File );
    
    has file => (
        is      => 'rw',
        isa     => File,
        coerce  => 1,
    );
    
    __END_OF_CLASS__;
    
    package main;
    
    my $instance = MyClass->new( file => { fullpath => '/path/to/file.txt' } );
    my $content  = $instance->file->slurp;

=head1 DESCRIPTION

This types are Tsukumo resource types.

=head1 TYPES

=head2 C<Resource>

=head2 C<File>

=head2 C<YAML>

=head2 C<Perl>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
