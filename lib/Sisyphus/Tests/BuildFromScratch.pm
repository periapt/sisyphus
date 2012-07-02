package Sisyphus::Tests::BuildFromScratch;
use Moose;
with 'Sisyphus::Testable',
     'Sisyphus::Session';
use YAML::XS;

sub run_test {
    my $self = shift;
    $self->command('apt-get --verbose update', 1);
    my $results = {
        results=>$self->command_results,
        pass=> $self->command_results->[0]->{exit}==0,
    };
    return Dump($results);
}
sub verify_results {
    my $self = shift;
    my $results = shift;
    return Load($results)->{pass};
}

=head1 NAME

Sisyphus::Tests::BuildFromScratch - flexible build from scratch test

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

The L<Sisyphus::Tests::BuildFromScratch> encapsulates building a
Debian package within a schroot.

=head1 ATTRIBUTES

=head1 METHODS

=head2 run_test

=head2 verify_results

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
