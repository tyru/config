use strict;
use warnings;
use inc::Module::Install;

name '<MODULE NAME>';
license 'perl';
perl_version '5.10.0';
author 'tyru <tyru.exe@gmail.com>';
version '0.01';

test_requires 'Test::More';
test_requires 'Test::Pod';
requires 'common::sense';
# requires 'Perl6::Slurp';
# requires 'File::Copy::Recursive';
# requires 'File::HomeDir';
# requires 'YAML';

install_script 'script/<MODULE NAME>';

WriteAll;
