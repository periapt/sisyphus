#! /usr/bin/perl -T

use Test::More tests => 4;
use lib qw(t/lib);
use Blah;

my $blah = Blah->new;
isa_ok($blah, 'Blah');
can_ok($blah, 'run_test', 'verify_results');
isnt($blah->has_run, 1, 'has not run');
$blah->run_test;
ok($blah->has_run, 'has run');

