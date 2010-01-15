package Tsukumo::Resource;

use strict;
use warnings;

use Tsukumo::Exceptions qw( argument_parameter_missing );
use Tsukumo::Utils qw( load_class );

sub new {
    my ( $class, %args ) = @_;

    my $source = delete $args{'source'}
        or argument_parameter_missing error => "Argument 'source' is required.", requires => [qw( source )];
    my $module;

    if ( $source =~ m{^[+](.+)$} ) {
        $module = $1;
    }
    else {
        $module = $class . q{::} . $source;
    }

    load_class($module);

    return $module->new( %args );
}

1;
__END__

=head1 NAME

Tsukumo::Resource - Resource class for Tsukumo.

=head1 SYNPOSIS

    use Tsukumo::Resource;
    
    my $file = Tsukumo::Resource->new(
        source      => 'File',
        format      => 'Perl',
        fullpath    => '/path/to/perl.pl',
    );

=head1 DESCRIPTION

This class is resource class for Tsukumo.

=head1 METHODS

=head2 C<new>

This method is constructor of C<Tsukumo::Resource>.

A required argument is C<source>, and resource class name specifies in this argument.

Arguments except C<source> is passed to constructor of C<Tsukumo::Resource::*> classes.

=head1 RESOURCE CLASS PROPERTIES

=head2 C<data>

This property returns resource data 

=head2 C<type>

This propety returns resource type.

=head2 C<created>

This property returns L<Tsukumo::Class::Date> object of resource created time

=head2 C<lastmodified>

This property returns L<Tsukumo::Class::Date> object of resource lastmodified time.

=head1 RESOURCE CLASS METHODS

=head2 C<reload>

This method is reload resource data.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Role::Resource>,

L<Tsukumo::Resource::File>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
