package Tsukumo::Types::Formatter;

use strict;
use Tsukumo::Class 'X::Types' => [ -declare => [qw(
    Formatter 
    PerlFormatter YAMLFormatter PlainTextFormatter
)] ];
use Tsukumo::Types::Builtin qw( Object Str ArrayRef HashRef );
use Tsukumo::Format;

subtype Formatter,
    as Object,
;

coerce Formatter,
    from Str,
        via { Tsukumo::Format->new( format => $_ ) },
    from ArrayRef,
        via { Tsukumo::Format->new( @{ $_ } ) },
    from HashRef,
        via { Tsukumo::Format->new( %{ $_ } ) },
;

subtype PerlFormatter,
    as Object,
;

coerce PerlFormatter,
    from ArrayRef,
        via { Tsukumo::Format->new( @{ $_ }, format => 'Perl' ) },
    from HashRef,
        via { Tsukumo::Format->new( %{ $_ }, format => 'Perl' ) },
;

subtype YAMLFormatter,
    as Object,
;

coerce YAMLFormatter,
    from ArrayRef,
        via { Tsukumo::Format->new( @{ $_ }, format => 'YAML' ) },
    from HashRef,
        via { Tsukumo::Format->new( %{ $_ }, format => 'YAML' ) },
;

subtype PlainTextFormatter,
    as Object,
;

coerce PlainTextFormatter,
    from ArrayRef,
        via { Tsukumo::Format->new( @{ $_ }, format => 'PlainText' ) },
    from HashRef,
        via { Tsukumo::Format->new( %{ $_ }, format => 'PlainText' ) },
;

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Types::Fomatter - Formatter (Moose|Mouse) types for Tsukumo.

=head1 SYNPOSIS

    package MyClass;
    
    use strict;
    use Tsukumo::Class;
    use Tsukumo::Types::Formatter qw( Formatter );
    
    has formatter => (
        is          => 'ro',
        isa         => Formatter,
        coerce      => 1,
        required    => 1,
    );
    
    __END_OF_CLASS__;
    
    package main;
    
    my $instance = MyClass->new( formatter => 'Perl' );

=head1 DESCRIPTION

This types are (Moose|Mouse) types for Tsukumo::Format classes.

=head1 TYPES

=head2 C<Formatter>

=head2 C<PerlFormatter>

=head2 C<YAMLFormatter>

=head2 C<PlainTextFormatter>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
