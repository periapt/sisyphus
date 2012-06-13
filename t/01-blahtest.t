#!perl -T

use Test::More tests => 2;
use lib qw(t/lib);
use Blah;

my $blah = Blah->new;
isa_ok($blah, 'Blah');
can_ok($blah, 'run_test', 'verify_results');
