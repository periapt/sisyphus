#!perl -T

use Test::More tests => 5;

BEGIN {
    use_ok( 'Sisyphus' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Testable' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Types' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Status' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::App' ) || print "Bail out!\n";
}

diag( "Testing Sisyphus $Sisyphus::VERSION, Perl $], $^X" );
