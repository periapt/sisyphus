package Sisyphus::Status;
use Moose;
use MooseX::Params::Validate;
use Sisyphus::Types qw(States);
use SDBM_File;

has filename => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has _impl => (
    is => 'ro',
    isa => 'HashRef',
    builder => '_builder_impl',
    lazy => 1,
);

sub _builder_impl {
    use Fcntl qw(O_CREAT O_RDWR);
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
    my ($self, %params) = validated_hash(
        \@_,
        name => { isa => 'Str' },
    );
    if (exists $self->_impl->{$params{name}}) {
        return $self->_impl->{$params{name}};
    }
    return 'UNTRIED';
}

sub set_status {
    my ($self, %params) = validated_hash(
        \@_,
        name => { isa => 'Str' },
        state => {isa => 'State' },
    );
    $self->_impl->{$params{name}} = $params{state};
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
