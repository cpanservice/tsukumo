package Tsukumo::Format::PlainText;

use Tsukumo::Class;
use Tsukumo::Role::Formatter;

with qw( Tsukumo::Role::Formatter );

sub name        { 'PlainText' }
sub extensions  {[qw( txt   )]}

sub parse {
    my ( $self, $source ) = @_;
    return "${source}";
}

sub format {
    my ( $self, $perl ) = @_;
    return "${perl}";
}

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Format::PlainText - parser and formatter for plain text

=head1 DESCRIPTION

    use Tsukumo::Format;
    
    my $format = Tsukumo::Format->new( format => 'PlainText' );
    
    my $var    = $format->parse( $perlvar );
    my $source = $format->format( $var );

=head1 DESCRIPTION

This class is parser and formatter for plain text.

=head1 CONSTRUCTOR ARGUMENTS

none.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut