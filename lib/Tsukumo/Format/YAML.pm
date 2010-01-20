package Tsukumo::Format::YAML;

use Tsukumo::Class;
use Tsukumo::Types::Builtin qw( HashRef Str );
use Tsukumo::Utils qw( load_class is_class_loaded );
use Tsukumo::Exceptions qw( required_module_missing );
use Tsukumo::Role::Formatter;

with qw( Tsukumo::Role::Formatter );

has implementation => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    builder => 'setup_implementation',
    trigger => sub { load_class($_[1]) },
);

sub setup_implementation {
    my ( $self ) = @_;

    my @order = qw(
        YAML::XS
        YAML::Syck
        YAML::Old
        YAML
        YAML::Tiny
    );

    for my $module ( @order ) {
        return $module if ( is_class_loaded($module) );
        return $module if ( load_class($module) );
    }

    required_module_missing error => 'YAML implementation module is not found.', requires => [@order];
}

sub name        { 'YAML' }
sub extensions  {[qw( yml yaml )]}

sub parse {
    my ( $self, $source ) = @_;
    my $impl = $self->implementation;

    return $impl->can('Load')->($source);
}

sub format {
    my ( $self, $perl ) = @_;
    my $impl = $self->implementation;
    return $impl->can('Dump')->($perl);
}

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Format::YAML - parse and format yaml forat.

=head1 SYNPOSIS

    my $format = Tsukumo::Format->new(
        format          => 'YAML',
        implementation  => 'YAML::XS',
    );
    
    my $var = $format->parse( $yaml );
    my $yaml = $format->format( $var );

=head1 DESCRIPTION

This class is paser and formatter yaml format.

=head1 CONSTRUCTOR ARGUMENTS

=head2 C<implementation>

This argument specifies YAML implementation module.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Format>

L<YAML>, L<YAML::XS>, L<YAML::Syck>, L<YAML::Old> and L<YAML::Tiny>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
