package Tsukumo::Class::Date;

use Tsukumo::Class;
use Tsukumo::Types::DateProperty qw( Epoch Year Month Day DayWeek Hour Minute Second TZOffset );
use Tsukumo::Types::Builtin qw( ArrayRef );

my @properties = qw( year month day dayweek hour minute second );

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

    $year   ||= [gmtime]->[5];
    $month  ||= 1;
    $day    ||= 1;
    $hour   ||= 0;
    $minute ||= 0;
    $second ||= 0;

    require Time::Local;
    return Time::Local::timegm( $second, $minute, $hour, $day, ( $month - 1 ), $year );
}

has __time => (
    is      => 'ro',
    isa     => ArrayRef,
    lazy    => 1,
    clearer => '_clear___time',
    builder => '_build___time',
);

sub _build___time {[ gmtime $_[0]->epoch ]}

has [ @properties ] => (
    trigger => sub {
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


sub _build_year     { $_[0]->__time->[5] + 1900 }
sub _build_month    { $_[0]->__time->[4] + 1    }
sub _build_day      { $_[0]->__time->[3]        }
sub _build_dayweek  { $_[0]->__time->[6]        }
sub _build_hour     { $_[0]->__time->[2]        }
sub _build_minute   { $_[0]->__time->[1]        }
sub _build_second   { $_[0]->__time->[0]        }

has tzoffset => (
    is      => 'rw',
    isa     => TZOffset,
    coerce  => 1,
    lazy    => 1,
    builder => '_build_tzoffset',
);

sub _build_tzoffset {
    my $now = time;
    require Time::Local;
    return Time::Local::timegm(localtime($now)) - Time::Local::timegm(gmtime($now));
}

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

    require Date::Parse;
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

=head1 NAME

Tsukumo::Class::Date - Datetime onject for Tsukumo.

=head1 SYNPOSIS

    use Tsukumo::Class::Date;

    my $date = Tsukumo::Class::Date->now;

=head1 DESCRIPTION

This class is datetime object for Tsukumo.

=head1 METHODS

=head2 C<new>

    my $date = Tsukumo::Class::Date->new( epoch => time );

=head2 C<parse_dwim>

    my $date = Tsukumo::Class::Date->parse_dwin($datetime);

This method parse datetime string.

Parse datetime string function is implemented by L<Date::Parse>.

Please see L<Date::Parse> about support datetime format.

=head2 C<now>

    my $now = Tsukumo::Class::Date->now;                # same as Tsukumo::Class::Date->new( time );

This method is same C<Tsukumo::Class::Date-E<gt>new( time )>.

=head2 C<clone>

    my $date = Tsukumo::Class::Date->now;
    my $clone = $date->clone;
    my $clone = $date->clone( year => 2009 );

This method is clone datetime object.

=head2 C<ymd>

    my $date = $date->ymd;      # YYYY-MM-DD
    my $date = $date->ymd('/'); # YYYY/MM/DD

=head2 C<time>

    my $time = $date->time;     # HH:MM:SS
    my $time = $date->time(':') # HH.MM.SS

=head2 C<w3cdtf>

    my w3cdtf = $date->w3cdtf;

This method is returned W3C datetime format datetime.

=head1 PROPERTIES

=head2 C<epoch>

=head2 C<year>

=head2 C<month>

=head2 C<day>

=head2 C<dayweek>

=head2 C<hour>

=head2 C<minute>

=head2 C<second>

=head2 C<tzoffset>

=head2 C<gmt>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Date::Parse>, L<Time::Local>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
