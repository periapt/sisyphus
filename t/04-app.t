#! /usr/bin/perl  

use Test::More tests => 2;
use Sisyphus::App;
use File::Path qw(remove_tree);
use Test::Deep;

mkdir 't/tmp';

subtest dry_run => sub {
    plan tests => 7;
    my $app = Sisyphus::App->new_with_config(
        dry_run => 1,
        configfile=>'t/etc/sisyphus.yaml',
    );
    isa_ok($app, 'Sisyphus::App');
    is($app->dry_run, 1);
    is($app->workspace_dir, 't/tmp');
    is(ref $app->tests, 'ARRAY');
    my $summary = $app->get_status_summary('{\'%s\'=>\'%s\'},');
    cmp_deeply(eval "[$summary]", [{test1=>'UNTRIED'},{test2=>'UNTRIED'},{test3=>'UNTRIED'},{test4=>'UNTRIED'},{test5=>'UNTRIED'}], 'summary');
    is($app->run, 1);
    $summary = $app->get_status_summary('{\'%s\'=>\'%s\'},');
    cmp_deeply(eval "[$summary]", [{test1=>'UNTRIED'},{test2=>'UNTRIED'},{test3=>'UNTRIED'},{test4=>'UNTRIED'},{test5=>'UNTRIED'}], 'summary');
};


subtest real_thing => sub {
    plan tests => 6;
    my $app = Sisyphus::App->new_with_config(
        configfile=>'t/etc/sisyphus.yaml',
    );
    isa_ok($app, 'Sisyphus::App');
    is($app->dry_run, 0);
    is($app->workspace_dir, 't/tmp');
    is(ref $app->tests, 'ARRAY');
    my $summary = $app->get_status_summary('{\'%s\'=>\'%s\'},');
    cmp_deeply(eval "[$summary]", [{test1=>'UNTRIED'},{test2=>'UNTRIED'},{test3=>'UNTRIED'},{test4=>'UNTRIED'},{test5=>'UNTRIED'}], 'summary');
    is($app->run, 1);
    $summary = $app->get_status_summary('{\'%s\'=>\'%s\'},');
    cmp_deeply(eval "[$summary]", [{test1=>'PASS'},{test2=>'FAIL'},{test3=>'PASS'},{test4=>'SKIPPED'},{test5=>'PASS'}], 'summary');
};

remove_tree('t/tmp');
