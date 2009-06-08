use strict;
use warnings;
use Module::Build;

Module::Build->new(
    module_name         => '<MAIN MODULE>',
    license             => '<LICENSE>',
    dist_author         => '<AUTHOR> <<EMAIL>>',
    dist_version_from   => '<MAIN PM FILE>',
    requires => {
        'Test::More' => 0,
        'Test::Pod' => 0,
        'Test::Perl::Critic' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ '<DISTRO>-*' ],
)->create_build_script;

