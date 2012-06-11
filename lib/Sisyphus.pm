package Sisyphus;

use 5.006;
use strict;
use warnings;

=head1 NAME

Sisyphus - automated Debian pre-upload testing

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Before uploading a Debian packages a number of tests should ideally 
be completed successfully: building from scratch, lintian cleanliness,
piuparts, blhc, building dependent packages and other application
specific tests. In order to catch issues as early as possible it would
be nice to be able to run these tests against what is currently checked
into the repository.

The tests are done in a schroot environment that the script keeps uptodate.
The tests are configurable so can be adapted to specific needs.
Tests have dependencies which can be both other tests and anything
that can be coded as a Perl function.

=head1 AUTHOR

Nicholas Bamber, C<< <nicholas at periapt.co.uk> >>

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Nicholas Bamber.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Sisyphus
