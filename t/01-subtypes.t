#! /usr/bin/perl -T

use Test::More tests => 7;
use Sisyphus::Types qw(EmailAddress States);

is(is_EmailAddress('Nicholas Bamber <nicholas@periapt.co.uk>'), 1);
is(is_EmailAddress('Nicholas Bamber XnicholasXperiapt.co.uk>'), undef);
is(is_EmailAddress('<Nicholas Bamber <nicholas@periapt.co.uk>'), 1);

is(is_States('PASS'), 1, 'pass');
is(is_States('FAIL'), 1, 'fail');
is(is_States('SKIPPED'), 1, 'skipped');
is(is_States('UNTRIED'), 1, 'untried');

