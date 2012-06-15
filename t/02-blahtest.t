#! /usr/bin/perl  -T
BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' }

use Test::More tests => 21;
use Test::Moose;
use Test::Exception;
use lib qw(t/lib);
use Blah;
use NeverSatisfied;

my $blah = Blah->new(contact_on_pass=>'nicholas@periapt.co.uk');
isa_ok($blah, 'Blah');
can_ok($blah, 'run_test', 'verify_results');
does_ok($blah, 'Sisyphus::Testable');
has_attribute_ok($blah, 'has_run');
has_attribute_ok($blah, 'depends_on');
is_deeply($blah->depends_on, []);
is($blah->contact_on_pass, 'nicholas@periapt.co.uk');
is($blah->contact_on_fail, 'nicholas@periapt.co.uk');
ok($blah->check_preconditions, 'check_preconditions - 1');
isnt($blah->has_run, 1, 'has not run');
is($blah->has_passed, 0, 'has not passed');
is($blah->name, 'Blah', 'name');
is($blah->results, 'blah');
ok($blah->has_run, 'has run');
ok($blah->has_passed, 'passed');

my $neversatisfied = NeverSatisfied->new(
    depends_on=>['chk1','chk2'],
    contact_on_pass=>'nicholas@periapt.co.uk',
    contact_on_fail=>'periapt@debian.org',
    name=>'test2',
);
is_deeply($neversatisfied->depends_on, ['chk1','chk2']);
is($neversatisfied->check_preconditions, 0, 'check_preconditions - 0');
throws_ok(sub{$neversatisfied->results}, qr/could not find any results/);
is($neversatisfied->contact_on_pass, 'nicholas@periapt.co.uk');
is($neversatisfied->contact_on_fail, 'periapt@debian.org');
is($neversatisfied->name, 'test2', 'name');

