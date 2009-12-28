#!perl

use strict;
use warnings;

use Tsukumo::Types qw( Date );
use Test::More tests => 7;

is( Date, 'Tsukumo::Types::Date' );

my $date = Tsukumo::Class::Date->now;

ok( Date->check( $date ) );
ok( ! Date->check( time ) );

my $time = time;

is_deeply(
    [ Date->coerce($time) ],
    [ Tsukumo::Class::Date->new($time) ],
);

is_deeply(
    [ Date->coerce('2009-01-01T00:00:00Z') ],
    [ Tsukumo::Class::Date->parse_dwim('2009-01-01T00:00:00Z') ],
);

is_deeply(
    [ Date->coerce([ 0, 0, 0, 1, 0, 1970 ]) ],
    [ Tsukumo::Class::Date->timegm( 0, 0, 0, 1, 0, 1970) ],
);

is_deeply(
    [ Date->coerce({ year => 2009, month => 12, day => 24 }) ],
    [ Tsukumo::Class::Date->new_from_hash( year => 2009, month => 12, day => 24 ) ],
);