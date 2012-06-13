#! /usr/bin/perl -T

use Test::More tests => 16;
use Test::Moose;
use Test::Exception;
use lib qw(t/lib);
use Blah;
use NeverSatisfied;

my $blah = Blah->new();
isa_ok($blah, 'Blah');
can_ok($blah, 'run_test', 'verify_results');
does_ok($blah, 'Sisyphus::Testable');
has_attribute_ok($blah, 'has_run');
has_attribute_ok($blah, 'depends_on');
is_deeply($blah->depends_on, []);
ok($blah->check_preconditions, 'check_preconditions - 1');
isnt($blah->has_run, 1, 'has not run');
is($blah->results, undef);
is($blah->has_passed, 0, 'has not passed');
$blah->run_test;
ok($blah->has_run, 'has run');
is($blah->results, 'blah');
ok($blah->has_passed, 'passed');

my $neversatisfied = NeverSatisfied->new(depends_on=>['chk1','chk2']);
is_deeply($neversatisfied->depends_on, ['chk1','chk2']);
is($neversatisfied->check_preconditions, 0, 'check_preconditions - 0');
throws_ok(sub{$neversatisfied->run_test}, qr/could not find any results/);

