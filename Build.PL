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
        'Test::Deep' => 0,
        'Test::File'=> 0,
        'Test::Compile'=>0,
        'Test::NoWarnings' => 0,
        'Moose' => 0,
        'Moose::Role' => 0,
        'Email::Sender' => 0,
        'MooseX::Types' => 0,
        'MooseX::Params::Validate' => 0,
        'MooseX::Getopt' => 0,
        #'MooseX::Getopt::Usage' => 0,
        'Email::Address' => 0,
        'DateTime' => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Sisyphus-*', 'README' ],
    create_makefile_pl => 'traditional',
    create_readme => 1,
);

$builder->create_build_script();
