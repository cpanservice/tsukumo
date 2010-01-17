use inc::Module::Install;
name 'Tsukumo';
all_from 'lib/Tsukumo.pm';

## -- required by core modules ------ ##

## OO

# Tsukumo::Class, Tsukumo::Role, Tsukumo::Types, Tsukumo::Types::Builtin
requires 'Mouse' => 0.45;
requires 'MouseX::Types';
requires 'parent';
requires 'constant';

## class utility

# Tsukumo::Class::Hookable, Tsukumo::Exceptions, Tsukumo::Utils
requires 'Class::Hookable' => 0.08;
requires 'Exception::Class';
requires 'Exporter::Lite';
requires 'Class::Load';

## variable utility

# Tsukumo::Class::Variables,
requires 'Scalar::Util';
requires 'Encode';
requires 'Hash::Merge::Simple';

# Tsukumo::Format
requires 'Struct::Compare';

# Tsukumo::Format::Perl
requires 'Data::Dumper';

# Tsukumo::Format::YAML
requires 'YAML';

##  datetime

# Tsukumo::Class::Date, Tsukumo::Types::Date
requires 'Time::Local';
requires 'Date::Parse';

## path, filesys

# Tsukumo::Utils, Tsukumo::Types ( FilePath, FileName, FileExtension )
requires 'File::Spec::Unix';

# Tsukumo::Role::File
requires 'Coro::Handle';
requires 'File::stat';

## -- required by test files -------- ##

# core requires
test_requires 'Test::More';

# t::Utils
test_requires 'Path::Class';
test_requires 'FindBin';

## ---------------------------------- ##

tests 't/*/*/*.t';
author_tests 'xt';

auto_include;
auto_install;

WriteAll;
