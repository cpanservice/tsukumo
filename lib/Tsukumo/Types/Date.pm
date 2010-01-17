package Tsukumo::Types::Date;

use strict;
use Tsukumo::Class (
    'X::Types' => [ -declare => [qw(
        Epoch Year Month Day DayWeek Hour Minute Second TZOffset TimeZone
    )] ]
);
use Tsukumo::Types::Builtin qw( Str Int Object );

subtype Epoch,
    as Int,
    where { $_ >= 0 },
    message { "Argument '$_' is not positive number." }
;

subtype Year,
    as Int,
    where { $_ >= 1970 },
    message { "A year has to be after 1970." }
;

subtype Month,
    as Int,
    where { 1 <= $_ && $_ <= 12 };
    message { "The month has to be 1 to 12." }
;

subtype Day,
    as Int,
    where { 1 <= $_ && $_ <= 31 },
    message { "The day has to be 1 to 31" }
;

subtype DayWeek,
    as Int,
    where { 0 <= $_ && $_ <= 6 },
    message { "The dayweek has to be 0 to 6" }
;

subtype Hour,
    as Int,
    where { 0 <= $_ && $_ <= 23 },
    message { "A hour has to be 0 to 23" }
;

subtype Minute,
    as Int,
    where { 0 <= $_ && $_ <= 59 },
    message { "A minute has to be 0 to 59" }
;

subtype Second,
    as Int,
    where { 0 <= $_ && $_ <= 60 },
    message { "A second has to be 0 to 60" }
;

subtype TimeZone,
    as Str,
    where { $_ eq 'Z' || $_ =~ m{^[\-+]\d{2}:\d{2}$} },
    message { 'Invalid timezone format.' }
;

subtype TZOffset,
    as Int,
;

coerce TZOffset,
    from TimeZone,
        via {
            my $zone = $_;
            if ( $zone eq 'Z' ) {
                return 0;
            }

            my ( $pm, $hour, $minute )
                = ( $zone =~ m{^([\-+])(\d{2}):(\d{2})$} );

            my $time    = ( $hour * 60 * 60 ) + ( $minute * 60 );
               $time    *= -1 if ( $pm eq '-' );

            return $time;
        }
;

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Types::Date - date property types for L<Tsukumo::Class::Date>.

=head1 SYNPOSIS

    use MyDate;
    use Tsukumo::Class;
    use Tsukumo::Types::Date qw( Epoch );
    
    has epoch => (
        is => 'rw',
        isa => Epoch,
    );

=head1 TYPES

=head2 C<Epoch>

=head2 C<Year>

=head2 C<Month>

=head2 C<Day>

=head2 C<DayWeek>

=head2 C<Hour>

=head2 C<Minute>

=head2 C<Second>

=head2 C<TimeZone>

=head2 C<TZOffset>

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
