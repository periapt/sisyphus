package Blah;
use Moose;
with 'Sisyphus::Testable';

sub run_test { 'blah' }
sub verify_results {
    my $self = shift;
    my $results = shift;
    return $results eq 'blah';
}

1
