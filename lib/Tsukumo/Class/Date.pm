package Tsukumo::Class::Date;

use strict;
use warnings;

use base qw( Time::Piece );

sub w3cdtf {
    my $self = shift;

    my $date    = $self->datetime;
    my $offset  = $self->tzoffset;
    my $tz;

    if ( $offset == 0 ) {
        $tz = 'Z'
    }
    else {
        my $pm  = ( $offset > 0 ) ? '+' : '-';
        my $hr  = int( $offset / ( 60 * 60 ) );
        my $min = ( $offset - ( $hr * 60 * 60 ) ) / 60;

        $tz = "${pm}" . sprintf('%02d', $hr) . ':' . sprintf('%02d', $min);
    }

    return "${date}${tz}";
}

1;
__END__

=head1 NAME

Tsukumo::Class::Date - L<Time::Piece> subclass for Tsukumo

=head1 SYNPOSIS

    use Tsukumo::Class::Date;
    
    my $time = gmtime( time );
    
    print $time->year;

=head1 DESCRIPTION

This class is L<Time::Piece> subclass for Tsukumo.

=head1 METHODS

See L<Time::Piece> document.

=head2 C<w3cdtf>

    my w3cdtf = localtime->w3cdtf;

This method is returned W3C datetime format datetime.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
