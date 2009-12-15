package Tsukumo::Utils;

use strict;
use Tsukumo::Class;

extends 'Exporter::Lite';

our @EXPORT_OK = qw(
    env_value
);

sub env_value {
    my ( $key ) = @_;

    my $prefix  = uc 'Tsukumo';
       $key     = uc $key;
    my $env     = "${prefix}_${key}";

    if ( exists $ENV{$env} ) {
        return $ENV{$env};
    }

    return;
}

__END_OF_CLASS__;
