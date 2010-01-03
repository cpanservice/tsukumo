#!perl

use strict;
use warnings;

use Test::More tests => 5;

our $time = time;

{
    package MyResource;
    
    use strict;
    use Tsukumo::Class;
    
    with 'Tsukumo::Role::Resource';
    
    sub type { 'MyResource' }
    
    sub load {
        return 'foo';
    }
    
    sub write {
        main::ok(1);
    }
    
    sub datestat {
        return {
            created         => $main::time,
            lastmodified    => $main::time,
        };
    }
    
    __END_OF_CLASS__;
}

my $res = MyResource->new();

is( $res->type, 'MyResource' );
is( $res->data, 'foo' );
$res->write;
is_deeply(
    [ $res->created ],
    [ Tsukumo::Class::Date->new($time) ],
);
is_deeply(
    [ $res->lastmodified ],
    [ Tsukumo::Class::Date->new($time) ],
);
