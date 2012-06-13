package Blah;
use Moose;
with 'Sisyphus::Testable';

sub run_test {
    my $self = shift;
    $self->results('blah');
}
sub verify_results {
    return 1;
}

1
