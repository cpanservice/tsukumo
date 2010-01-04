package Tsukumo::Class::Date;

use strict;
use warnings;

use parent qw( Time::Piece );

use Tsukumo::Exceptions;
use Date::Parse ();
use Time::Local ();

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

sub parse_dwim {
    my ( $class, $str ) = @_;
    my $time = Date::Parse::str2time($str);

    return $class->gmtime( $time );
}

sub timegm {
    my $class = shift;
    my @args  = @_;

    my $offset;
       $offset = pop @args if ( @args == 7 );
       $offset = 0 if ( ! defined $offset );

    my $time = Time::Local::timegm(@args);

    return $class->gmtime( $time + $offset );
}

sub new_from_hash {
    my ( $class, %args ) = @_;

    my $year    = delete $args{'year'} or Tsukumo::Exception::InvalidArgumentError->throw( error => q{Argument 'year' is not set.} );
    my $month   = ( delete $args{'month'}   || 1 ) - 1;
    my $day     = delete $args{'day'}       || 1;
    my $hr      = delete $args{'hour'}      || 0;
    my $min     = delete $args{'minute'}    || 0;
    my $sec     = delete $args{'second'}    || 0;
    my $offset  = delete $args{'offset'}    || 0;
    $year       = $year - 1900;

    my $time    = Time::Local::timegm( $sec, $min, $hr, $day, $month, $year );
    return $class->gmtime( $time + $offset );
}

sub clone {
    my ( $self, %args ) = @_;

    $args{'year'}   ||= $self->year;
    $args{'month'}  ||= $self->mon;
    $args{'day'}    ||= $self->mday;
    $args{'hour'}   ||= $self->hour;
    $args{'minute'} ||= $self->min;
    $args{'second'} ||= $self->sec;
    $args{'offset'} ||= scalar($self->tzoffset);

    return $self->new_from_hash( %args );
}

sub now {
    my ( $class, $offset ) = @_;

    $offset ||= 0;

    return $class->gmtime( time + $offset );
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

=head2 C<new_from_hash>

    my $date = Tsukumo::Class::Date->new_from_hash(
        year    => 2009,
        month   => 12,
        day     => 24,
        hour    => 12,
        minute  => 10,
        second  => 30,
        offset  => 9 * 60 * 60,
    );

This method is make instance from hash.

=head2 C<parse_dwim>

    my $date = Tsukumo::Class::Date->parse_dwin($datetime);

This method parse datetime string.

Parse datetime string function is implemented by L<Date::Parse>.

Please see L<Date::Parse> about support datetime format.

=head2 C<timegm>

    my $date = Tsukumo::Class::Date->timegm( 0, 0, 0, 1, 1, 1970 );

Same as:

    my $date = Tsukumo::Class::Date->gmtime( Time::Local::timegm( 0, 0, 0, 1, 1, 1970 ) );

See also L<Time::Local>.

=head2 C<now>

    my $now = Tsukumo::Class::Date->now;                # same as Tsukumo::Class::Date->new( time );
    my $now = Tsukumo::Class::Date->now( $tzoffset );   # same as Tsukumo::Class::Date->new( time + $tzoffset );

This method is same C<Tsukumo::Class::Date-E<gt>new( time )>.

=head2 C<clone>

    my $date = Tsukumo::Class::Date->now;
    my $clone = $date->clone;
    my $clone = $date->clone( year => 2009 );

This method is clone datetime object.



=head2 C<w3cdtf>

    my w3cdtf = localtime->w3cdtf;

This method is returned W3C datetime format datetime.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Date::Parse>, L<Time::Local>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
