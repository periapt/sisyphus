#! /usr/bin/perl -T

use Test::More tests => 11;
use Test::Moose;
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
ok($blah->check_dependencies, 'check_dependencies - 1');
isnt($blah->has_run, 1, 'has not run');
$blah->run_test;
ok($blah->has_run, 'has run');


my $neversatisfied = NeverSatisfied->new(depends_on=>['chk1','chk2']);
is_deeply($neversatisfied->depends_on, ['chk1','chk2']);
is($neversatisfied->check_dependencies, 0, 'check_dependencies - 0');

