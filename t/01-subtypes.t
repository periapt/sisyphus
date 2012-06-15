#! /usr/bin/perl -T

use Test::More tests => 3;
use Sisyphus::Types qw(EmailAddress);

is(is_EmailAddress('Nicholas Bamber <nicholas@periapt.co.uk>'), 1);
is(is_EmailAddress('Nicholas Bamber XnicholasXperiapt.co.uk>'), undef);
is(is_EmailAddress('<Nicholas Bamber <nicholas@periapt.co.uk>'), 1);
