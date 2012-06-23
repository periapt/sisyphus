package Sisyphus::App;
use Moose;

#with 'MooseX::Getopt::Usage';
with 'MooseX::SimpleConfig',
     'MooseX::Getopt';

has dry_run => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
    documentation => qq{Just say what we would do; not actually do it.},
);

has clean_test_workspace => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
    documentation => qq{Clean the directory and associated schroots before starting.},
);

has list_test_status => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
    documentation => qq{List the status of the tests.},
);

has retry_test => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
    documentation => qq{Mark the given test UNTRIED. Can be applied multiple times.},
);

=head1 NAME

Sisyphus::App - core functionality of sisyphus

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

L<Sisyphus::App> provides a persistent record of which
tests have successfully run. This is so that after a hardware
failure or perhaps a tweak to the configuration, tests may be
resumed. Four states are supported: 'PASS', 'FAIL', 'SKIPPED' or
'UNTRIED'. The last is the default state.

=head1 METHODS

=head2 get_status

Takes a name and returns the corresponding state.

=head2 set_status

Takes a name and a state and records the status accordingly.

=head2 remove_old_file

This is called on creation to force a complete test run, if that
is required.

=head2 DEMOLISH

=cut

our $VERSION = '0.01';

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
