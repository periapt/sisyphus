package Sisyphus::App;
use Moose;

with 'MooseX::SimpleConfig',
     'MooseX::Getopt';
use Sisyphus::Types qw(WritableDirectory);
use Sisyphus::Status;
use UNIVERSAL::require;

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

has default_args => (
    is => 'ro',
    isa => 'HashRef[Str]',
    default => sub {{}},
    documentation => qq{Arguments to be passed to every test unless overridden.},
);

has '+configfile' => (
    default => '/etc/sisyphus.yaml',
    documentation => qq{Config file. Defaults to /etc/sisyphus.yaml.},
);

has workspace_dir => (
    is => 'ro',
    isa => WritableDirectory,
    documentation => qq{Directory used to store all test related data.},
);

has tests => (
    is => 'ro',
    isa => 'Maybe[ArrayRef]',
    documentation => qq{List of tests to be run.},
);

has _status => (
    is => 'ro',
    isa => 'Sisyphus::Status',
    lazy => 1,
    builder => '_builder_status',
);

sub run {
    my $self = shift;
    foreach my $test (@{$self->tests}) {
        my $name = $test->{name};
        my $state = $self->_status->get_status($name);
        next if $state ne 'UNTRIED';
        my $module = $test->{module};
        if (not exists $test->{args}) {
            $test->{args} = {};
        }
        my %args = (%{$self->default_args}, %{$test->{args}});
        $module->require;
        my $test_obj = $module->new(%args);
        if (not $test_obj) {
            warn $@;
            $self->_status->set_status($name, 'SKIPPED');
            next;
        }
        if (not $self->_check_depends(@{$test_obj->depends_on})) {
            $self->_status->set_status($name, 'SKIPPED');
            next;
        }
        if (not $test_obj->check_preconditions) {
            $self->_status->set_status($name, 'SKIPPED');
            next;
        }
        if ($self->dry_run) {
            $self->_status->set_status($name, 'PASS');
        }
        else {
            my $status = 'FAIL';
            my $results = eval {$test_obj->results};
            if ($@) {
                $self->_status->set_status($name, $status);
            }
            print $results;
            $self->_status->set_status(
                $name,
                $test_obj->has_passed ? 'PASS' : 'FAIL'
            );
        }
    }
    return 1;
}

sub get_status_summary {
    my $self = shift;
    my $line_format = shift;
    my $summary = "";
    foreach my $test (@{$self->tests}) {
        my $name = $test->{name};
        my $state = $self->_status->get_status($name);
        $summary .= sprintf $line_format, $name, $state;
    }
    return $summary;
}

sub _builder_status {
    my $self = shift;
    my $filename = $self->workspace_dir."/sisyphus";
    my $status = Sisyphus::Status->new(
        filename => $filename,
        dry_run => $self->dry_run,
    );
    foreach my $retry (@{$self->retry_test}) {
        $status->set_status($retry, 'UNTRIED');
    }
    return $status;
}

sub _check_depends {
    my $self = shift;
    my @depends = @_;
    foreach my $test (@depends) {
        return 0 if $self->_status->get_status($test) ne 'PASS';
    }
    return 1;
}

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

=head2 run

This method reads the list of tests from config file, runs each
test and records the state in the status object.

=head2 get_status_summary

Returns a sting representing the current test status. The string 
is a concatenation of smaller strings, whose format is determined
by the line format parameter, which is a C<sprintf> format string.
The line format parameter must contain two C<%s> directives. The
first is for the test name and the secon for the corresponding
L<Sisyphus::Types::State> value.


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
