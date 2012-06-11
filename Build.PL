use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Sisyphus',
    license             => 'perl',
    dist_author         => q{Nicholas Bamber <nicholas@periapt.co.uk>},
    dist_version_from   => 'lib/Sisyphus.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Sisyphus-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
