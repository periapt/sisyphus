package NeverSatisfied;
use Moose;
with 'Sisyphus::Testable';

sub run_test {}
sub verify_results {return 1;}
sub check_dependencies {return 0;}

1
