use inc::Module::Install;
name 'Tsukumo';
all_from 'lib/Tsukumo.pm';

# core modules
requires 'Any::Moose';

# Tsukumo::Utils
requires 'Expoter::Lite';

tests 't/*/*/*.t';
author_tests 'xt';

test_requires 'Test::More';

auto_include;
auto_install;

WriteAll;
