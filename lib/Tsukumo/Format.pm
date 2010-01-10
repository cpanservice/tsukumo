package Tsukumo::Format;

use strict;
use warnings;

use Struct::Compare;
use Tsukumo::Utils qw( load_class );
use Tsukumo::Exceptions qw( argument_parameter_missing );

my %CACHE = ();

sub new {
    my ( $class, %args ) = @_;

    my $format = delete $args{'format'}
        or argument_parameter_missing error => "required 'format' paramter.";
    my $module;

    if ( $format =~ m{^[+](.*)$} ) {
        $module = $1;
    }
    else {
        $module = $class . q{::} . $format;
    }

    load_class($module);

    my $instance;
    my $is_cached = 0;
    if ( exists $CACHE{$module} ) {
        for my $cache ( @{ $CACHE{$module} } ) {
            if ( compare( \%args, $cache->{'args'} ) ) {
                $instance   = $cache->{'instance'};
                $is_cached  = 1;
            }
            else {
                $instance   = $module->new( %args );
                $is_cached  = 0;
            }
        }
    }
    else {
        $instance   = $module->new( %args );
        $is_cached  = 0;
    }

    if ( ! $is_cached ) {
        $CACHE{$module} = [] if ( ! exists $CACHE{$module} );
        push @{ $CACHE{$module} }, +{
            instance    => $instance,
            args        => { %args },
        };
    }

    return $instance;
}

1;
__END__

=head1 NAME

Tsukumo::Format - Parser and Formatter for Tsukumo.

=head1 SYNPOSIS

    use Tsukumo::Format;
    
    my $format  = Tsukumo::Format->new( format => 'Perl' );
    
    my $perlvar = $format->parse( $perlcode );
    my $perlcode = $format->format( $perlvar );

=head1 DESCRIPTION

This class is formatter dispatcher for C<Tsukumo::Format::*> classes.

=head1 METHODS

=head2 C<new>

    # use Tsukumo::Format::Perl
    my $format = Tsukumo::Format->new(
        format => 'Perl',   
        %args,
    );
    
    # use My::Format::Class
    my $format = Tsukumo::Format->new(
        format => '+My::Format::Class',
    );

This method makes an instance of C<Tsukumo::Format::*> classes.

A required argument is C<format>, and, format class name is set in this argument.

Arguments except C<format> is passed to constructor of C<Tsukumo::Format::*> classes.

This method is cached an instance.

When you set the same argument as before,
this method returns the same instance as last time.

=head1 FORMATTER METHODS

=head2 C<name>

    my $name = $format->name;

This method returns formatter name.

=head2 C<extensions>

    my @extensions = @{ $format->extensions };

This method returns a supported file extensions.

=head2 C<parse>

    my $perlvar = $format->parse( $source );

This method parses source code.

=head2 C<format>

    my $source = $format->parse( $perlvar );

This method formats perl structure.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
