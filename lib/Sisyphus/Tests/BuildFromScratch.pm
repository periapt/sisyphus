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

1
