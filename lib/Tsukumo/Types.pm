package Tsukumo::Types;

use Tsukumo::Class (
    'X::Types'  => [ -declare => [qw(
        Config
    )] ]
);
use Tsukumo::Types::Builtin qw( Object HashRef );
use Tsukumo::Config;

# Config
subtype Config,
    as Object,
    where { $_->isa('Tsukumo::Config') },
    message { "Object is not Tsukumo::Config object." }
;

coerce Config,
    from HashRef,
        via { Tsukumo::Config->new( $_ ) }
;


__END_OF_CLASS__;

1;

__END__

=head1 NAME

Tsukumo::Types - (Moose|Mouse) types for Tsukumo.

=head1 SYNPOSIS

    package Foo;
    
    use Tsukumo::Class;
    use Tsukumo::Types qw( Config );
    
    has config => (
        is      => 'rw',
        isa     => Config,
        coerce  => 1,
    );
    
    __END_OF_CLASS__;

=head1 DESCRIPTION

This class is provider (Moose|Mouse) types for Tsukumo.

=head1 TYPES

=head2 C<Config>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
