package Sisyphus::Status;
use Moose;
use MooseX::Params::Validate;
use Sisyphus::Types qw(States);
use Fcntl;
use SDBM_File;

has filename => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has _impl => (
    is => 'ro',
    isa => 'HashRef',
    lazy => 1,
    builder => '_builder_impl',
    clearer => 'purge',
);

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
