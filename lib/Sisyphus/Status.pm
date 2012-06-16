package Sisyphus::Status;
use Moose;
use Sisyphus::Types qw(State);
use MooseX::Params::Validate;
use SDBM_File;
use Fcntl qw(O_CREAT O_RDWR);

has filename => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has _test => (
    is => 'ro',
    lazy => 1,
    builder => '_builder_test',
);

sub _builder_test {
    my $self = shift;
    my %h;
    return \%h;
}

has _impl => (
    is => 'ro',
    builder => '_builder_impl',
    lazy => 1,
);

sub _builder_impl {
    my $self = shift;
    my %h;
    my $filename = $self->filename;
    tie(%h, 'SDBM_File', $filename, O_RDWR|O_CREAT, 0666)
        or die "Couldn't tie SDBM file '$filename': $!; aborting";
    return \%h;
}

sub remove_old_file {
    my $self = shift;
    unlink $self->filename;
    return;
}

sub DEMOLISH {
    my $self = shift;
    untie %{$self->_impl};
    return;
}

sub get_status {
    my $self = shift;
    my ($name) = pos_validated_list(
        \@_,
        {isa => 'Str'},
    );
    if (exists $self->_impl->{$name}) {
        return $self->_impl->{$name};
    }
    return 'UNTRIED';
}

sub set_status {
    my ($self, $name, $state) = pos_validated_list(
        \@_,
        {isa => 'Sisyphus::Status'},
        {isa => 'Str'},
        {isa => 'Sisyphus::Types::State' },
    );
    $self->_impl->{$name} = $state;
    return;
}

=head1 NAME

Sisyphus::Status - persistent record of test results

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

L<Sisyphus::Status> provides a persistent record of which
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
