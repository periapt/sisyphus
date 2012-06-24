#! /usr/bin/perl  

use Test::More tests => 2;
use Sisyphus::App;

subtest dry_run => sub {
    plan tests => 4;
    my $app = Sisyphus::App->new_with_config(
        dry_run => 1,
        configfile=>'t/etc/sisyphus.yaml',
    );
    isa_ok($app, 'Sisyphus::App');
    is($app->dry_run, 1);
    is($app->workspace_dir, 't/tmp');
    is(ref $app->tests, 'ARRAY');
};


subtest real_thing => sub {
    plan tests => 4;
    my $app = Sisyphus::App->new_with_config(
        configfile=>'t/etc/sisyphus.yaml',
    );
    isa_ok($app, 'Sisyphus::App');
    is($app->dry_run, 0);
    is($app->workspace_dir, 't/tmp');
    is(ref $app->tests, 'ARRAY');
};


