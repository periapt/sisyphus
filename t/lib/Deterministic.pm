package Deterministic;
use Moose;
with 'Sisyphus::Testable';

sub run_test {}
sub verify_results {
    my $self = shift;
    my $results = shift;
    return $results eq 'PASS';
}

1
