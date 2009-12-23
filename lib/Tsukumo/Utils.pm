package Tsukumo::Utils;

use strict;
use warnings;

use base qw( Exporter::Lite );
use File::Spec::Unix;

our @EXPORT_OK = qw(
    env_value rel2abs
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

sub rel2abs {
    my $path    = shift;
    my $is_dir  = $path =~ m{/$};
       $path    = File::Spec::Unix->canonpath($path);
       $path    =~ s{^/*}{};
       $path    =~ s{/*$}{};
       $path    = "/${path}";
       $path    = "${path}/"    if ( $is_dir );
       $path    =~ s{/+}{/};
    return $path;
}

1;

=head1 NAME

Tsukumo::Utils - Utility for Tsukumo

=head1 SYNPOSIS

    use Tsukumo::Utils @subs;

=head1 FUNCTIONS

=head2 C<env_value>

    use Tsukumo::Utils qw( env_value );
    
    my $file = env_value('config') # get $ENV{'TSUKUMO_CONFIG'}

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
