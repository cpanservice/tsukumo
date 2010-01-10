package Tsukumo::Exceptions;

use strict;
use warnings;

use parent qw( Exporter::Lite );

my %E;
BEGIN {
    %E = (
        'Tsukumo::Exception'                            => {
            decription  => 'Basic exception for Tsukumo',
        },
        'Tsukumo::Exception::InvalidArgumentError'      => {
            isa         => 'Tsukumo::Exception',
            alias       => 'invalid_argument_error',
            description => 'Argument is not valid',
        },
        'Tsukumo::Exception::ArgumentParameterMissing'  => {
            isa         => 'Tsukumo::Exception',
            alias       => 'argument_parameter_missing',
            fields      => [qw( requires )],
            description => 'Required argument parameter is missing.',
        },
    );
}

use Exception::Class ( %E );

$_->Trace(1) for keys %E;

our @EXPORT_OK;
for my $def ( values %E ) {
    if ( exists $def->{'alias'} ) {
        push @EXPORT_OK, $def->{'alias'};
    }
}

1;

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

=head2 C<Tsukumo::Exception::InvalidArgumentError>

    invalid_argument_error error => $message;

basic exceptions.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Exception::Class>, L<Exception::Class::Base>

=head1 LICENSE

=cut
