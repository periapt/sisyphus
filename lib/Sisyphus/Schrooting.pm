package Sisyphus::Session;
use Moose::Role;
use 5.006;
use System::Command;
use File::Which;
use Perl6::Slurp;
use MooseX::Params::Validate;

has is_working => (
    is => 'ro',
    isa => 'Bool',
    lazy => 1,
    builder => '_build_is_working',
);

sub _build_is_working {
    my $self = shift;
    return which('schroot');
}

has session => (
    is => 'ro',
    isa => 'Maybe[Str]',
    lazy => 1,
    builder => '_build_session',
);

sub _build_session {
    my $self = shift;
    my $system = System::Command->new('schroot -b -c sisyphus');
    return slurp $system->stdout() if $system->exit() == 0;
    warn $system->stderr;
    return 0;
}

has command_outputs => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { [] },
);

sub DEMOLISH {
    my $self = shift;
    my $session = $self->session;
    my $system = System::Command->new("schroot -e -c $session");
    warn $system->stderr if $system->exit();
    return;
}

sub command {
    my $self = shift;
    my ($command, $run_as_root) = pos_validated_list(
        \@_,
        {isa => 'Str'},
        {isa => 'Bool', default => 0},
    );
    my $session = $self->session;
    my $full_command = "schroot -r -c $session";
    if ($run_as_root) {
        $full_command .= ' -u root';
    }
    $full_command .= " -- $command";
    my $system = System::Command->new($full_command);
    $system->close();
    my %results = ();
    $results{cmdline} = $system->cmdline();
    $results{pid} = $system->pid();
    $results{stderr} = slurp $system->stderr();
    $results{stdout} = slurp $system->stdout();
    $results{exit} = $system->exit();
    $results{core} = $system->core();
    $results{signal} = $system->signal();
    push @{$self->command_outputs}, \%results;
    return;
}

=head1 NAME

Sisyphus::Schrooting - builds a session and runs commands in it

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    package Sisyphus::Blah;
    use Moose;
    with 'Sisyphus::Schrooting';

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

=head2 start_time, stop_time

These are L<DateTime> objects captured just before and after the test is
run.

=head2 strftime_format

This is the format used to display the timestamps in the email.

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
