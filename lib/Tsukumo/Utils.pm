package Tsukumo::Utils;

use strict;
use warnings;

use parent qw( Exporter::Lite );
use File::Spec::Unix;
use Tsukumo::Exceptions;
use Class::Load qw( load_class is_class_loaded );

our $is_moosed;

BEGIN {
    if ( exists $INC{'Class/MOP.pm'} ) {
        $is_moosed = 1;
    }
    elsif ( eval { require Mouse } ) {
        $is_moosed = 0;
    }
    elsif ( eval { require Moose } ) {
        $is_moosed = 1;
    }
    else {
        Tsukumo::Exception->throw( error => 'Unable to locate Mouse or Moose in INC' );
    }
};

our @EXPORT_OK = qw(
    env_value rel2abs load_class is_class_loaded any_moose is_moosed
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

my %PathCache = ();

sub rel2abs {
    my $source  = shift;

    if ( exists $PathCache{$source} ) {
        return $PathCache{$source};
    }

    my $path    = $source;
    my $is_dir  = $path =~ m{/$};
       $path    = File::Spec::Unix->canonpath($path);
       $path    =~ s{^/*}{};
       $path    =~ s{/*$}{};
       $path    = "/${path}";
       $path    = "${path}/"    if ( $is_dir );
       $path    =~ s{/+}{/};

    $PathCache{$source} = $path;

    return $path;
}

my %ClassCache = ();
sub any_moose {
    my ( $arg ) = @_;
         $arg   = q{} if ( ! defined $arg );

    if ( exists $ClassCache{$arg} ) {
        return $ClassCache{$arg};
    }

    my $class = $arg;
    $class = 'Moose' if ( $arg eq q{} );
    $class =~ s{^X::}{MooseX::};
    $class =~ s{^::}{Moose::};
    $class =~ s{^Mouse(X?)\b}{Moose$1};
    $class =~ s{^(?!Moose)}{Moose::};

    if ( ! $is_moosed ) {
        $class =~ s{^Moose}{Mouse};
    }

    $ClassCache{$arg} = $class;

    return $class;
}

sub is_moosed { $is_moosed };

1;

=head1 NAME

Tsukumo::Utils - Utility for Tsukumo

=head1 SYNPOSIS

    use Tsukumo::Utils @subs;

=head1 FUNCTIONS

=head2 C<env_value>

    use Tsukumo::Utils qw( env_value );
    
    my $file = env_value('config') # get $ENV{'TSUKUMO_CONFIG'}

This function is getting C<$ENV{"TSUKUMO_${argument}"}> value.

If not defined C<$ENV{"TSKUMO_${argument}"}>, this function is returned nothing.

=head2 C<rel2abs>

    use Tsukumo::Utils qw( rel2abs );
    
    my $path = rel2abs('path/to/././file.txt');
       $path # '/path/to/file.txt';

This function is logical cleanup of a argument path.

=head2 C<is_moosed>

    use Tsukumo::Utils qw( is_moosed );
    
    my $mode = ( is_moosed() ) ? 'Moose' : 'Mouse' ;

This function retruns Moose mode or Mouse mode.

if this function is returned true, class builder is Moose.

=head2 C<any_moose>

    use Tsukumo::Utils qw( any_moose );
    
    my $builder     = any_moose;
    my $metaclass   = any_moose('::Meta::Class');

This function is geneator of (Moose|Mouse) class names.

=head2 C<load_class>

    load_class('Class::Name')

This method is module loader.

=head2 C<is_class_loaded>

    my $loaded = is_class_loaded('Class::Name')

Tis method checks class is loaded.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
