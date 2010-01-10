package Tsukumo::Format::Perl;

use strict;
use Tsukumo::Class;
use Tsukumo::Exceptions qw( evaluate_code_failed );
use Tsukumo::Types::Builtin qw( HashRef );
use Data::Dumper ();
use Scalar::Util ();

use Tsukumo::Role::Formatter;
with qw( Tsukumo::Role::Formatter );

has dumper_options => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { +{} },
);

sub name        { 'Perl' }
sub extensions  {[qw( pl perl )]}

sub parse {
    my ( $self, $source ) = @_;

    my $data;
    local $@;
    eval { $data = eval $source };

    if ( $@ ) {
        evaluate_code_failed error => "Cannot parse perl code: ${@}";
    }

    return $data;
}

sub format {
    my ( $self, $perl ) = @_;

    my %options = (
        Terse   => 1,
        Deparse => 1,
        Useqq   => 1,
        Indent  => ( ( Scalar::Util::blessed($perl) && $perl->isa('CODE') ) || ref $perl eq 'CODE' ) ? 2 : 1 ,
        %{ $self->dumper_options },
    );

    my $dumper = Data::Dumper->new([ $perl ]);
    $dumper->$_( $options{$_} ) for keys %options;

    $dumper->Dump;
}

__END_OF_CLASS__;
1;