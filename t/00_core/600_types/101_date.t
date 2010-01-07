#!perl

use strict;
use warnings;

use Tsukumo::Types qw( DateTime );
use Test::More tests => 7;

is( DateTime, 'Tsukumo::Types::DateTime' );

my $date = Tsukumo::Class::Date->now;

ok( DateTime->check( $date ) );
ok( ! DateTime->check( time ) );

my $time = time;

is_deeply(
    [ DateTime->coerce($time) ],
    [ Tsukumo::Class::Date->new(epoch => $time) ],
);

is_deeply(
    [ DateTime->coerce('2009-01-01T00:00:00Z') ],
    [ Tsukumo::Class::Date->parse_dwim('2009-01-01T00:00:00Z') ],
);

is_deeply(
    [ DateTime->coerce([ year => 2009, month => 12, day => 24 ]) ],
    [ Tsukumo::Class::Date->new( year => 2009, month => 12, day => 24 ) ],
);

is_deeply(
    [ DateTime->coerce({ year => 2009, month => 12, day => 24 }) ],
    [ Tsukumo::Class::Date->new( year => 2009, month => 12, day => 24 ) ],
);