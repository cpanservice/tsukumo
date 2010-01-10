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
        'Tsukumo::Exception::EvaluateCodeFailed'        => {
            isa         => 'Tsukumo::Exception',
            alias       => 'evaluate_code_failed',
            description => 'Evaluate perl code is failed.',
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

    use Tsukumo::Exceptions qw( invalid_argument_error );

    invalid_argument_error error => $message;

=head2 C<Tsukumo::Exception::ArgumentParameterMissing>

    use Tsukumo::Exceptions qw( argument_parameter_missing );
    
    argument_parameter_mission error => $message, requires => $requires_parameter.

=head2 C<Tsukumo::Exception::EvaluateCodeFailed>

    use Tsukumo::Exceptions qw( evaluate_code_failed );
    
    evaluate_code_filed error => $message;

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Exception::Class>, L<Exception::Class::Base>

=head1 LICENSE

=cut
