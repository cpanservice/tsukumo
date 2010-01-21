package Tsukumo::Types::Path;

use Tsukumo::Class 'X::Types' => [ -declare => [qw( FilePath FileName FileExtension )] ];
use Tsukumo::Types::Builtin qw( Str ArrayRef Object );
use Tsukumo::Utils qw( rel2abs );

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
    from Object,
        via { rel2abs( "${_}" ) },
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
        },
    from Object,
        via {
            my $filename = "${_}";
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
    from Object,
        via {
            my $ext = "${_}";
               $ext =~ s{^\.}{};
            return $ext;
        }
;

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Types::Path - (Moose|Mouse) types of file path property.

=head1 SYNPOSIS

    use MyFile;
    
    use Tsukumo::Class;
    use Tsukumo::Types::Path qw( FilePath );
    
    has fullpath => (
        is          => 'rw',
        isa         => FilePath,
        coerce      => 1,
        required    => 1,
    );
    
    __END_OF_CLASS__;
    
    package main;
    
    my $file = MyFile->new( fullpath => '/path/to/file.txt' );
       $file->fullpath;

=head1 DESCRIPTION

This types are filepath property types for Tsukumo.

=head1 TYPES

=head2 C<FilePath>

=head2 C<FileName>

=head2 C<FileExtension>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thtoep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
