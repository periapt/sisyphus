#! /usr/bin/perl  

use Test::More tests => 2;
use Sisyphus::App;

subtest dry_run => sub {
    plan tests => 2;
    my $app = Sisyphus::App->new(
        dry_run => 1,
    );
    isa_ok($app, 'Sisyphus::App');
    is($app->dry_run, 1);
};


subtest real_thing => sub {
    plan tests => 2;
    my $app = Sisyphus::App->new();
    isa_ok($app, 'Sisyphus::App');
    is($app->dry_run, 0);
};


