package Sisyphus::Testable;
use Moose::Role;
use Sisyphus::Types qw(EmailAddress);
use DateTime;
use Carp;
use 5.006;

requires 'run_test';
requires 'verify_results';

has results => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_results',
);

has name => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_name',
);

has start_time => (
    is => 'ro',
    isa => 'DateTime',
    writer => '_start_time',
);

sub _build_name {
    my $self = shift;
    return ($self->meta->class_precedence_list)[0];
}

has contact_on_pass => (
    is => 'ro',
    required => 1,
    isa => EmailAddress,
);

has contact_on_fail => (
    is => 'ro',
    isa => EmailAddress,
    writer => '_contact_on_fail',
    lazy => 1,
    builder => '_build_contact_on_fail',
);

sub _build_contact_on_fail {
    my $self = shift;
    return $self->contact_on_pass;
}

has has_run => (
    is  => 'ro',
    isa => 'Bool',
    writer => '_has_run',
    default => 0,
);

has has_passed => (
    is  => 'ro',
    isa => 'Bool',
    writer => '_has_passed',
    default => 0,
);

sub _build_results {
    my $self = shift;

    my $results = $self->run_test;
    croak "could not find any results" if not $results;

    $self->_has_run(1);

    my $email_contact = $self->contact_on_pass;
    if ($self->verify_results($results)) {
        $self->_has_passed(1);
    }
    else {
        $email_contact = $self->contact_on_fail;
    }

    return $results;
};

has depends_on => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub {[]},
);

sub check_preconditions {
    return 1;
}

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

    sub run_test {return "Does this look okay?"}
    sub verify_results {my $self = shift; return $self =~ /okay/;}

=head1 DESCRIPTION

The L<Sisyphus::Testable> role encapsulates the sort of test run by the
sisyphus script. The calling script decides whether to run the test
based upon the value of the C<depends_on> attribute and the output
of the C<check_preconditions>. To actually the test all it needs to
do is access the C<results> attribute. The role will take care of reporting
the results. The calling script can query the other attributes for its own
purposes.

=head1 ATTRIBUTES

=head2 has_run

By default this starts a false, and becomes true
after C<run_test> is run.

=head2 depends_on

A list of checks for the calling script to verify
before running the test. The calling script can structure these values
how it likes.

=head2 results

Access this runs the C<run_test> method and captures all the associated data.

=head2 contact_on_pass

Who passed test results are sent to. This is a required field.

=head2 contact_on_fail

Who failed test results are sent to. This defaults to C<contact_on_fail>.

=head2 name

The C<name> attribute is used by sisyphus to identify a particular test
and its results. For the absolutely lazy it defaults to the class name.

=head1 METHODS

=head2 check_preconditions

By default this returns 1. A consuming class may override this
to give a test external dependencies.

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
