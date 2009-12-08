use inc::Module::Install;
name 'Tsukumo';
all_from 'lib/Tsukumo.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
