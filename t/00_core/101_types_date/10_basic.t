#!perl

use strict;
use warnings;

use Test::More;
use Tsukumo::Types::Date qw( Epoch Year Month Day DayWeek Hour Minute Second TZOffset TimeZone );

ok( Epoch->check(0) );
ok( ! Epoch->check(-1) );

ok( Year->check(1970) );
ok( Year->check(2009) );
ok( ! Year->check(1049) );

for my $num ( 1 .. 12 ) {
    ok( Month->check($num) );
}
ok( ! Month->check(-1) );
ok( ! Month->check(14) );

for my $num ( 1 .. 31 ) {
    ok( Day->check($num) );
}
ok( ! Day->check(-1) );
ok( ! Day->check(32) );

for my $num ( 0 .. 6 ) {
    ok( DayWeek->check($num) );
}

ok( ! DayWeek->check(-1) );
ok( ! DayWeek->check(7) );

for my $num ( 0 .. 23 ) {
    ok( Hour->check($num) );
}

ok( ! Hour->check(-1) );
ok( ! Hour->check(24) );

for my $num ( 0 .. 59 ) {
    ok( Minute->check($num) );
}

ok( ! Minute->check(-1) );
ok( ! Minute->check(60) );

for my $num ( 0 .. 60 ) {
    ok( Second->check($num) );
}

ok( ! Second->check(-1) );
ok( ! Second->check(61) );

ok( TimeZone->check('Z') );
ok( TimeZone->check('+09:00') );
ok( TimeZone->check('-09:00') );

ok( TZOffset->check(90) );
ok( TZOffset->check(-20) );

is(
    TZOffset->coerce('Z'),
    0,
);

is(
    TZOffset->coerce('+09:00'),
    9 * 60 * 60,
);

is(
    TZOffset->coerce('-02:00'),
    -1 * 2 * 60 * 60,
);

done_testing;
