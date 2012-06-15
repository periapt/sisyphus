#! /usr/bin/perl  
BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' }

use Test::More tests => 26;
use Test::Deep;
use Test::Moose;
use Test::Exception;
use lib qw(t/lib);
use Blah;
use NeverSatisfied;

my $blah = Blah->new(
    contact_on_pass=>'nicholas@periapt.co.uk',
    sender=>'sisyphus@periapt.co.uk',
);
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
is($blah->sender, 'sisyphus@periapt.co.uk');
is($blah->results, 'blah');
ok($blah->has_run, 'has run');
ok($blah->has_passed, 'passed');
my @deliveries = Email::Sender::Simple->default_transport->deliveries;
cmp_deeply(\@deliveries,
    [
        {
            failures=>[],
            successes=>['nicholas@periapt.co.uk'],
            envelope=>ignore(),
            email=>(bless [noclass({
                header=>{headers=>[
                        'To', 'nicholas@periapt.co.uk',
                        'From', 'sisyphus@periapt.co.uk',
                        'Subject', re(qr/Blah: \[SUCCESS\] ran at/),
                        'Date', ignore(),
                    ],mycrlf=>ignore()},
                mycrlf=>ignore(),
                body=>ignore()}),'Email::Abstract::EmailSimple'], 'Email::Abstract'),
        },
    ],
    'deliveries'
);
my $stash = $deliveries[0];
like(${$stash->{email}->[0]->{body}}, qr/blah/, 'email body');

my $neversatisfied = NeverSatisfied->new(
    depends_on=>['chk1','chk2'],
    contact_on_pass=>'nicholas@periapt.co.uk',
    contact_on_fail=>'periapt@debian.org',
    name=>'test2',
    sender=>'sisyphus@debian.org',
);
is_deeply($neversatisfied->depends_on, ['chk1','chk2']);
is($neversatisfied->check_preconditions, 0, 'check_preconditions - 0');
like($neversatisfied->results, qr/could not find any results/);
is($neversatisfied->contact_on_pass, 'nicholas@periapt.co.uk');
is($neversatisfied->contact_on_fail, 'periapt@debian.org');
is($neversatisfied->name, 'test2', 'name');
is($neversatisfied->sender, 'sisyphus@debian.org');
@deliveries = Email::Sender::Simple->default_transport->deliveries;
cmp_deeply(\@deliveries,
    [
        $stash,
        {
            failures=>[],
            successes=>['nicholas@periapt.co.uk'],
            envelope=>ignore(),
            email=>(bless [noclass({
                header=>{headers=>[
                        'To', 'nicholas@periapt.co.uk',
                        'From', 'sisyphus@debian.org',
                        'Subject', re(qr/test2: \[SUCCESS\] ran at/),
                        'Date', ignore(),
                    ],mycrlf=>ignore()},
                mycrlf=>ignore(),
                body=>ignore()}),'Email::Abstract::EmailSimple'], 'Email::Abstract'),
        },
    ],
    'deliveries'
);

