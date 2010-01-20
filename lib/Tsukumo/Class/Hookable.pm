package Tsukumo::Class::Hookable;

use Tsukumo::Class;

extends 'Class::Hookable';

has class_hookable_stash => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { +{} },
);

sub class_hookable_filter_prefix { 'filter' }

__END_OF_CLASS__;

=head1 NAME

Tsukumo::Class::Hookable - Base class for hook mechanism

=head1 SYNPOSIS

    package Foo;

    use strict;
    use Tsukumo::Class;
    
    extends 'Tsukumo::Class::Hookable';
    
    __END_OF_CLASS__
    
    package main;
    
    my $hook = Foo->new;
    
    $hook->register_hook( $instance, 'hook.point' => $instance->can('action') );
    $hook->run_hook('hook.point' => $args);

=head1 DESCRIPTION

This class is the base class for hook mechanism.

This class is based L<Class::Hookable>

=head1 METHODS

See L<Class::Hookable> document.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 SEE ALSO

L<Tsukumo::Class>, L<Class::Hookable>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
