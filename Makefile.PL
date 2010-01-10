use inc::Module::Install;
name 'Tsukumo';
all_from 'lib/Tsukumo.pm';

# core modules
requires 'Mouse'        => 0.45;
requires 'parent';
requires 'constant';

# Tsukumo::Utils
requires 'Expoter::Lite';
requires 'File::Spec::Unix';
requires 'Class::Load';

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
requires 'Time::Local';
requires 'Date::Parse';

# Tsukumo::Role::File
requires 'File::stat';
requires 'IO::File';

# Tsukumo::Types
requires 'MouseX::Types';
requires 'MouseX::Types::Mouse';

tests 't/*/*/*.t';
author_tests 'xt';

test_requires 'Test::More';

build_requires 'Path::Class';
build_requires 'FindBin';

auto_include;
auto_install;

WriteAll;
