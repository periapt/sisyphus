package Deterministic;
use Moose;
with 'Sisyphus::Testable';

has results_value => (
    is => 'ro',
    isa => 'Str',
);

sub run_test {
    my $self = shift;
    return $self->results_value;
}
sub verify_results {
    my $self = shift;
    my $results = shift;
    return $results eq 'PASS';
}

1
