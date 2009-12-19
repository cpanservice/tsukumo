package Tsukumo::Exceptions;

use strict;
use Tsukumo::Class;

my %E;
BEGIN {
    %E = (
        'Tsukumo::Exception' => {
            decription => 'Basic exception for Tsukumo',
        }
    );
}

use Exception::Class ( %E );

$_->Trace(1) for keys %E;

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Exceptions - Exception classes for Tsukumo

=head1 SYNPOSIS

    use Tsukumo::Exceptions;
    use Try::Tiny;
    
    try {
        Tsukumo::Exception->throw( error => $message );
    }
    catch {
        my $e = shift;
        # do something
    };

=head1 DESCRIPTION

This class is some exception classes for Tsukumo.

=head1 EXCEPTIONS

=head2 C<Tsukumo::Exception>

basic exceptions.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Exception::Class>, L<Exception::Class::Base>

=head1 LICENSE

=cut
