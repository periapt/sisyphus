#!perl 

use Test::More tests => 9;
use Test::NoWarnings;
use Test::Compile;

BEGIN {
    use_ok( 'Sisyphus' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Testable' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Types' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Status' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::App' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Session' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Tests::BuildFromScratch' ) || print "Bail out!\n";
}

diag( "Testing Sisyphus $Sisyphus::VERSION, Perl $], $^X" );
pl_file_ok('bin/sisyphus');
