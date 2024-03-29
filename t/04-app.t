#! /usr/bin/perl  
BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' }

use Test::More tests => 2;
use Sisyphus::App;
use File::Path qw(remove_tree);
use Test::Deep;
use lib qw(t/lib);

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
    cmp_deeply(eval "[$summary]", [{test1=>'UNTRIED'},{test2=>'UNTRIED'},{test3=>'UNTRIED'},{test4=>'UNTRIED'},{test5=>'UNTRIED'}], 'summary completely untried');
    is($app->run, 1);
    $summary = $app->get_status_summary('{\'%s\'=>\'%s\'},');
    cmp_deeply(eval "[$summary]", [{test1=>'PASS'},{test2=>'PASS'},{test3=>'PASS'},{test4=>'PASS'},{test5=>'PASS'}], 'if in doubt dry run assumes tests pass');
};


subtest real_thing => sub {
    plan tests => 7;
    my $app = Sisyphus::App->new_with_config(
        configfile=>'t/etc/sisyphus.yaml',
    );
    isa_ok($app, 'Sisyphus::App');
    is($app->dry_run, 0);
    is($app->workspace_dir, 't/tmp');
    is(ref $app->tests, 'ARRAY');
    my $summary = $app->get_status_summary('{\'%s\'=>\'%s\'},');
    cmp_deeply(eval "[$summary]", [{test1=>'UNTRIED'},{test2=>'UNTRIED'},{test3=>'UNTRIED'},{test4=>'UNTRIED'},{test5=>'UNTRIED'}], 'dry run changes were not persisted');
    is($app->run, 1);
    $summary = $app->get_status_summary('{\'%s\'=>\'%s\'},');
    cmp_deeply(eval "[$summary]", [{test1=>'PASS'},{test2=>'FAIL'},{test3=>'PASS'},{test4=>'SKIPPED'},{test5=>'PASS'}], 'summary');
};

remove_tree('t/tmp');
