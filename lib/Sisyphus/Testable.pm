package Sisyphus::Testable;
use Moose::Role;
use 5.006;

requires 'run_test';
requires 'verify_results';

has has_run => (
    is  => 'ro',
    isa => 'Bool',
    writer => '_has_run',
    default => 0,
);

after 'run_test' => sub {
    my $self = shift;
    $self->_has_run(1);
    return;
};

has depends_on => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub {[]},
);

=head1 NAME

Sisyphus::Testable - something that runs a test and reports back

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    package Sisyphus::Test::Blah;
    use Moose;
    with 'Sisyphus::Testable';

    sub run_test {}
    sub verify_results {return 1;}

=head1 DESCRIPTION

The L<Sisyphus::Testable> role encapsulates the sort of test run by the
sisyphus script. The calling script decides whether to run the test
based upon the value of the C<depends_on> attribute and the output
of the C<check_dependencies>. To actually the test all it needs to
do is run the C<run_test> method. The role will take care of reporting
the results. The calling script can query the attributes for its own
purposes.

=head1 ATTRIBUTES

=over

=item B<has_run> - By default this starts a false, and becomes true
after C<run_test> is run.

=item B<depends_on> - A list of checks for the calling script to verify
before running the test. The calling script can structure these values
how it likes.

=back

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
