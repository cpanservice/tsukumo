use inc::Module::Install;
name 'Tsukumo';
all_from 'lib/Tsukumo.pm';

# core modules
requires 'Any::Moose';

# Tsukumo::Utils
requires 'Expoter::Lite';

# Tsukumo::Exceptions
requires 'Exception::Class';

# Tsukumo::Class::Hookable
requires 'Class::Hookable';

# Tsukumo::Class::Variables
requires 'Scalar::Util';
requires 'Encode';
requires 'Hash::Merge::Simple';

# Tsukumo::Class::Date
requires 'Time::Piece';

tests 't/*/*/*.t';
author_tests 'xt';

test_requires 'Test::More';

auto_include;
auto_install;

WriteAll;
