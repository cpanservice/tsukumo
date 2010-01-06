#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Tsukumo::Class::Date;

my $time    = Tsukumo::Class::Date->new( epoch => 0, tzoffset => 0 );
my $local   = Tsukumo::Class::Date->new( epoch => 0 );
my $offset  = $local->tzoffset;

is(
    $time->w3cdtf,
    '1970-01-01T00:00:00Z',
);

my $tz;
if ( $offset == 0 ) {
    $tz = 'Z';
}
else {
    my $pm  = ( $offset > 0 ) ? q{+} : q{-} ;
    my $hr  = int( $offset / ( 60 * 60 ) );
    my $min = ( $offset - ( $hr * 60 * 60 ) ) / 60;
    $tz     = $pm . sprintf('%02d', $hr) . ':' . sprintf('%02d', $min);
}

is(
    $local->w3cdtf,
    "1970-01-01T00:00:00${tz}",
);
