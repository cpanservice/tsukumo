package Tsukumo::Class::Date;

use strict;
use Tsukumo::Class;
use Tsukumo::Types::Date qw( Epoch TimePiece Year Month Day DayWeek Hour Minute Second TZOffset );

use Time::Local ();
use Date::Parse ();

my @properties = qw( year month day dayweek hour minute second );
my %isa = (
    year    => Year,
    month   => Month,
    day     => Day,
    dayweek => DayWeek,
    hour    => Hour,
    minute  => Minute,
    second  => Second,
);

has epoch => (
    is          => 'rw',
    isa         => Epoch,
    required    => 1,
    lazy        => 1,
    clearer     => 'clear_epoch',
    builder     => '_build_epoch',
    trigger     => sub {
        for my $property ( @properties ) {
            my $method = "clear_${property}";
            $_[0]->$method();
        }
        $_[0]->_clear___time;
        $_[0]->clear_gmt;
    },
);

sub _build_epoch {
    my ( $self ) = @_;

    if ( ! grep { exists $self->{$_} } @properties ) {
        return time;
    }

    my ( $year, $month, $day, $hour, $minute, $second )
        = @{ $self }{qw( year month day hour minute second )};

    $year   ||= Time::Piece->gmtime->year;
    $month  ||= 1;
    $day    ||= 1;
    $hour   ||= 0;
    $minute ||= 0;
    $second ||= 0;

    return Time::Local::timegm( $second, $minute, $hour, $day, ( $month - 1 ), ( $year - 1900 ) );
}

has __time => (
    is      => 'ro',
    isa     => TimePiece,
    coerce  => 1,
    lazy    => 1,
    clearer => '_clear___time',
    builder => '_build___time',
);

sub _build___time { return $_[0]->epoch }

has [ @properties ] => (
    tirgger => sub {
        $_[0]->clear_epoch;
        $_[0]->clear_gmt;
        $_[0]->_clear___time;
    },
);

has '+year' => (
    is      => 'rw',
    isa     => Year,
    lazy    => 1,
    clearer => 'clear_year',
    builder => '_build_year',
);

has '+month' => (
    is      => 'rw',
    isa     => Month,
    lazy    => 1,
    clearer => 'clear_month',
    builder => '_build_month',
);

has '+day' => (
    is      => 'rw',
    isa     => Day,
    lazy    => 1,
    clearer => 'clear_day',
    builder => '_build_day',
);

has '+dayweek' => (
    is      => 'ro',
    isa     => DayWeek,
    lazy    => 1,
    clearer => 'clear_dayweek',
    builder => '_build_dayweek',
);

has '+hour' => (
    is      => 'rw',
    isa     => Hour,
    lazy    => 1,
    clearer => 'clear_hour',
    builder => '_build_hour',
);

has '+minute' => (
    is      => 'rw',
    isa     => Minute,
    lazy    => 1,
    clearer => 'clear_minute',
    builder => '_build_minute',
);

has '+second' => (
    is      => 'rw',
    isa     => Second,
    lazy    => 1,
    clearer => 'clear_second',
    builder => '_build_second',
);


sub _build_year     { $_[0]->__time->year   }
sub _build_month    { $_[0]->__time->mon    }
sub _build_day      { $_[0]->__time->mday   }
sub _build_dayweek  { $_[0]->__time->wday   }
sub _build_hour     { $_[0]->__time->hour   }
sub _build_minute   { $_[0]->__time->minute }
sub _build_second   { $_[0]->__time->second }

has tzoffset => (
    is      => 'rw',
    isa     => TZOffset,
    coerce  => 1,
    lazy    => 1,
    builder => '_build_tzoffset',
);

sub _build_tzoffset { my $now = time; Time::Local::timegm(localtime($now)) - Time::Local::timegm(gmtime($now)) }

has gmt => (
    is      => 'ro',
    isa     => __PACKAGE__,
    lazy    => 1,
    clearer => 'clear_gmt',
    builder => '_build_gmt',
);

sub _build_gmt {
    my ( $self ) = @_;
    return __PACKAGE__->new(
        epoch       => $self->epoch + $self->tzoffset,
        tzoffset    => 0,
    );
}

sub parse_dwim {
    my ( $class, $date ) = @_;

    my ( $sec, $min, $hr, $da, $mo, $yr, $zone ) = Date::Parse::strptime($date);

    return $class->new(
        year        => $yr + 1900,
        month       => $mo + 1,
        day         => $da,
        hour        => $hr,
        minute      => $min,
        second      => $sec,
        tzoffset    => $zone,
    );
}

sub now { $_[0]->new( epoch => time ) }

sub clone {
    my ( $self, %args ) = @_;

    $args{'year'}       ||= $self->year;
    $args{'month'}      ||= $self->month;
    $args{'day'}        ||= $self->day;
    $args{'hour'}       ||= $self->hour;
    $args{'minute'}     ||= $self->minute;
    $args{'second'}     ||= $self->second;
    $args{'tzoffset'}   ||= $self->tzoffset;

    return $self->new( %args );
}

sub w3cdtf {
    my ( $self ) = @_;

    my $ymd     = $self->ymd('-');
    my $time    = $self->time(':');
    my $offset  = $self->tzoffset;

    my $tz;
    if ( $offset == 0 ) {
        $tz = 'Z';
    }
    else {
        my $pm  = ( $offset > 0 ) ? '+' : '-';
        my $hr  = int( $offset / ( 60 * 60 ) );
        my $min = ( $offset - ( $hr * 60 * 60 ) ) / 60;
           $tz  = "${pm}" . sprintf('%02d', $hr) . ':' . sprintf('%02d', $min);
    }

    return "${ymd}T${time}${tz}";
}

sub ymd {
    my ( $self, $sep ) = @_;
    $sep = q{-} if ( ! defined $sep );

    my $year    = $self->year;
    my $month   = sprintf('%02d', $self->month);
    my $day     = sprintf('%02d', $self->day);

    return join $sep, ( $year, $month, $day );
}

sub time {
    my ( $self, $sep ) = @_;
    $sep = q{:} if ( ! defined $sep );

    my $hour   = sprintf('%02d', $self->hour);
    my $minute = sprintf('%02d', $self->minute);
    my $second = sprintf('%02d', $self->second);

    return join $sep, ( $hour, $minute, $second );
}

__END_OF_CLASS__;


__END__

=pod

sub w3cdtf {
    my ( $self ) = @_;

    my $date    = $self->datetime;
    my $offset  = $self->tzoffset;

    my $tz;
    if ( $offset == 0 ) {
        $tz = 'Z';
    }
    else {
        my $pm  = ( $offset > 0 ) ? '+' : '-';
        my $hr  = int( $offset / ( 60 * 60 ) );
        my $min = ( $offset - ( $hr * 60 * 60 ) ) / 60;
           $tz  = "${pm}" . sprintf('%02d', $hr) . ':' . sprintf('%02d', $min);
    }

    return "${date}${tz}";
}

sub datetime {
    my ( $self ) = @_;

    my $ymd     = $self->ymd('-');
    my $time    = $self->time(':');

    return "${ymd}T${time}";
}

sub ymd {
    my $self = shift;
    my $sep  = shift;
       $sep  = q{-} if ( ! defined $sep );

    return join $sep, ( $self->year, $self->month, $self->day );
}

sub time {
    my $self = shift;
    my $sep  = shift;
       $sep  = q{:} if ( ! defined $sep );

    return join $sep, ( $self->hour, $self->minute, $self->second );
}

sub parse_dwim {
    my ( $class, $str ) = @_;

    my ()
        = 

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
