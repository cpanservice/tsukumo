package Tsukumo::Types;

use strict;
use Any::Moose;
use Any::Moose (
    'X::Types'                  => [ -declare => [qw(
        FilePath FileName FileExtension
    )] ],
    'X::Types::' . any_moose()  => [qw( Str ArrayRef )],
);

use Tsukumo::Utils qw( rel2abs );
use File::Spec::Unix;

subtype FilePath,
    as Str,
    where {
        $_ eq rel2abs($_)
    }
;

coerce FilePath,
    from Str,
        via { rel2abs($_) },
    from ArrayRef,
        via { rel2abs( File::Spec::Unix->catfile(@{ $_ }) ) },
;

subtype FileName,
    as Str,
    where { $_ !~ m{/} },
    message { "filename '${_}' includes slash." }
;

coerce FileName,
    from Str,
        via {
            my $filename = $_;
               $filename =~ s{^/*}{};
            return $filename;
        }
;

subtype FileExtension,
    as Str,
    where { $_ !~ m{\.} }
;

coerce FileExtension,
    from Str,
        via {
            my $ext = $_;
               $ext =~ s{^\.}{};
            return $ext;
        },
;


no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Tsukumo::Types - (Moose|Mouse) types for Tsukumo.

=head1 SYNPOSIS

    package Foo;
    
    use Tsukumo::Class;
    use Tsukumo::Types qw( FilePath );
    
    has filepath => (
        is  => 'rw',
        isa     => FilePath,
        coerce  => 1,
    );
    
    __END_OF_CLASS__;

=head1 DESCRIPTION

This class is provider (Moose|Mouse) types for Tsukumo.

=head1 TYPES

=head2 file path

=over

=item C<FilePath>

=item C<FileName>

=item C<FileExtension>

=back

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
s