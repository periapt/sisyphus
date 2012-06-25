#! /usr/bin/perl -T

use Test::More tests => 9;
use Sisyphus::Types qw(EmailAddress State WritableDirectory);

is(is_EmailAddress('Nicholas Bamber <nicholas@periapt.co.uk>'), 1);
is(is_EmailAddress('Nicholas Bamber XnicholasXperiapt.co.uk>'), undef);
is(is_EmailAddress('<Nicholas Bamber <nicholas@periapt.co.uk>'), 1);

is(is_State('PASS'), 1, 'pass');
is(is_State('FAIL'), 1, 'fail');
is(is_State('SKIPPED'), 1, 'skipped');
is(is_State('UNTRIED'), 1, 'untried');

is(is_WritableDirectory('/etc/motd'), undef, 'not a writable directory');
is(is_WritableDirectory('/tmp'), 1, 'writable directory');
