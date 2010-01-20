#!perl

use strict;
use warnings;

use Tsukumo::Class::Date;
use Test::More;
use Time::Local ();

my $time    = 0;
my $offset  = Time::Local::timegm(localtime(0)) - Time::Local::timegm(gmtime(0));
my $date = Tsukumo::Class::Date->new( epoch => $time );


is( $date->epoch, 0 );
is( $date->year, 1970);
is( $date->month, 1 );
is( $date->day,   1 );
is( $date->dayweek, 4 );
is( $date->hour,  0 );
is( $date->minute, 0 );
is( $date->second, 0 );
is( $date->tzoffset, $offset );
is( $date->gmt->epoch, $time + $offset );
is( $date->gmt->tzoffset, 0 );

$date->year(2010);
$date->month(1);
$date->day(12);
$date->hour(13);
$date->minute(34);
$date->second(31);

is( $date->epoch, Time::Local::timegm( 31, 34, 13, 12, 0, 2010 - 1900 ) );

done_testing;
