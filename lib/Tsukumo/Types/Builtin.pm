package Tsukumo::Types::Builtin;

use strict;
use warnings;

use Tsukumo::Class;
use Tsukumo::Class qw(
    X::Types
    ::Util::TypeConstraints
);
use Tsukumo::Utils ();

use constant type_storage => {
    map { $_ => $_ } Tsukumo::Utils::any_moose('::Util::TypeConstraints')->list_all_builtin_type_constraints
};


__END_OF_CLASS__;

__END__

=head1 NAME

Tsukumo::Types::Builtin - Built-in (Moose|Mouse) types for Tsukumo.

=head1 SYNPOSIS

    package Foo;
    
    use strict;
    use Tsukumo::Class;
    use Tsukumo::Types::Builtin qw( Str );
    
    has bar => (
        is => 'rw',
        isa => Str,
    );
    
    __END_OF_CLASS__;

=head1 SEE ALSO

L<MooseX::Types>, L<MouseX::Types>,

L<MooseX::Types::Moose>, L<MouseX::Types::Mouse>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
