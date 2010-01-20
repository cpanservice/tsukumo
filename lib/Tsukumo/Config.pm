package Tsukumo::Config;

use strict;
use warnings;

use Tsukumo::Class::Variables;
use parent qw( Tsukumo::Class::Variables );


1;
__END__

=head1 NAME

Tsukumo::Config - Configuration hash object for Tsukumo.

=head1 SYNPOSIS

    use Tsukumo::Config;
    
    my $config = Tsukumo::Config->new({});

=head1 DESCRITION

This class is configuration hash class for Tsukumo.

This class inherits L<Tsukumo::Class::Variables>.

=head1 METHODS

See L<Tsukumo::Class::Variables> document.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Class::Variales>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
