package Tsukumo::Class::Variables;

use strict;
use warnings;

use Scalar::Util qw( reftype );
use Encode ();
use Tsukumo::Exceptions qw( invalid_argument_error );

sub new {
    my ( $class, $var ) = @_;

    invalid_argument_error error => 'Argument is not HASH reference.'
        if ( ref $var ne 'HASH' );

    my $self = bless $var, $class;

    return $self;
}

sub visit {
    my ( $self, $callback ) = @_;

    invalid_argument_error error => 'Argument is not CODE reference.'
        if ( ref $callback ne 'CODE' );

    for my $key ( keys %{ $self } ) {
        $self->{$key} = $self->_visit( $self->{$key}, $callback );
    }

    return $self;
}

sub _visit {
    my ( $self, $var, $callback ) = @_;

    invalid_argument_error error => 'Argument is not CODE reference.'
        if ( ref $callback ne 'CODE' );

    my $type = reftype $var;

    if ( $type && $type eq 'HASH'  ) {
        for my $key ( keys %{ $var } )  {
            $var->{$key} = $self->_visit( $var->{$key}, $callback );
        }
    }
    elsif ( $type && $type eq 'ARRAY' ) {
        for ( @{ $var } ) {
            $_ = $self->_visit( $_, $callback );
        }
    }
    else {
        $var = $callback->( $self, $var );
    }

    return $var;
}

sub decode {
    my ( $self, $encoding ) = @_;

    my $enc = Encode::find_encoding($encoding);

    $self->visit(sub {
        my ( $vars, $var ) = @_;
        return $enc->decode( $var );
    });

    return $self;
}

sub encode {
    my ( $self, $encoding ) = @_;

    my $enc = Encode::find_encoding($encoding);

    $self->visit(sub {
        my ( $vars, $var ) = @_;
        return $enc->encode( $var );
    });

    return $self;
}

sub interpolate {
    my ( $self, %args ) = @_;

    my $regexp  = delete $args{'regexp'}    || qr{ \$ [{] ([a-zA-Z0\-_.]+) (?:[(] (.+?) [)])? [}] }sx;
    my $capture = delete $args{'capture'}   || [qw( name args )],
    my $source  = delete $args{'vars'}      || {};

    invalid_argument_error error => "Argument 'capture' is not ARRAY reference"
        if ( ref $capture ne 'ARRAY' );
    invalid_argument_error error => "Argument 'vars' is not HASH reference."
        if ( ref $source ne 'HASH' );

    my %vars;
    for my $var ( keys %{ $source } ) {
        if ( ref $source->{$var} eq 'CODE' ) {
            $vars{$var} = $source->{$var};
        }
        else {
            $vars{$var} = sub { $source->{$var} };
        }
    }

    $self->visit(sub {
        my ( $vars, $var ) = @_;

        while ( my @matched = ( $var =~ $regexp ) ) {
            my %matched;
            @matched{ @{ $capture } } = @matched;
            my ( $name, $args ) = @matched{qw( name args )};

            my $ret = q{};
            if ( exists $vars{$name} && ref $vars{$name} eq 'CODE' ) {
                $ret = $vars{$name}->( $vars, $name, $args );
            }

            $var =~ s{$regexp}{$ret};
        }

        return $var;
    });

    return $self;
}

1;
__END__

=head1 NAME

Tsukumo::Class::Variables - Variables class for Tsukumo

=head1 SYNPOSIS

    use Tsukumo::Class::Variables;
    
    my $vars = Tsukumo::Class::Variables->new( \%vars );
    
    $vars->decode('utf8');

=head1 DESCRIPTION

This class is variables class for Tsukumo.

=head1 METHODS

=head2 C<new>

    my $vars = Tsukumo::Class::Variables->new( \%vars );

This method is constructor of Tsukumo::Class::Variables.

=head2 C<visit>

    $vars->visit(sub {
        my ( $self, $var ) = @_;
        # do something
    });

This method is visitor of hash tree.

Callback of an argument is called every value of the hash tree.

=head2 C<decode>

    $vars->decode('utf8');

Hash tree is decoded by C<Encode::decode>.

=head2 C<encode>

    $vars->encode('utf8');

Hash tree is encoded by C<Encode::encode>.

=head2 C<interpolate>

    my $vars = Tsukumo::Class::Variable->new({
        foo => '${foo}',
        bar => '${bar(args)}',
    });

    $vars->interpolate(
        regexp  => qr{$regexp},
        captuer => [qw( name args )],
        vars    => {
            foo => 'AAA',
            bar => sub {
                my ( $vars, $name, $args ) = @_;
                # do something
                return 'BBB',
            },
        }
    );

    $vars->{'foo'} # 'AAA'
    $vars->{'bar'} # 'BBB'

This method is interpolating hash tree.

Arguments:

=over

=item C<regexp>

Regular expression of variables in the value of hash tree.

A variable in the value of hash tree is replaced by this regular expression.

default regexp is C<${foo}>, C<${func(args)}>.

=item C<capture>

Capture of a regular expression.

Captured over value, C<name> and C<args> are used.

default is C<[qw( name args )]>.

=item C<vars>

The value replaced with variables.

It is necessary to be a hash including scalar or the CODE rreference.

=back

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[ at ]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

