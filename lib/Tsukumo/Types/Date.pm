package Tsukumo::Types::Date;

use Tsukumo::Class 'X::Types' => [ -declare => [qw( Date )] ];
use Tsukumo::Types::Builtin qw( Str Int Object ArrayRef HashRef );
use Tsukumo::Class::Date;

subtype Date,
    as Object,
    where { $_->isa('Tsukumo::Class::Date') },
    message { "Object is not Tsukumo::Class::Date object: ${_}" }
;

coerce Date,
    from Int,
        via { Tsukumo::Class::Date->new( epoch => $_ ) },
    from Str,
        via { Tsukumo::Class::Date->parse_dwim($_) },
    from ArrayRef,
        via { Tsukumo::Class::Date->new( @{ $_ } ) },
    from HashRef,
        via { Tsukumo::Class::Date->new( %{ $_ } ) },
;

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Types::Date - Date type for Tsukumo.

=head1 SYNPOSIS

    package MyClass;
    
    use Tsukumo::Class;
    use Tsukumo::Types::Date qw( Date );
    
    has date => (
        is  => 'rw',
        isa => Date,
    );
    
    __END_OF_CLASS__;

=head1 DESCRIPTION

This type is datetime type for Tsukumo.

=head1 TYPES

=head2 C<Date>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
