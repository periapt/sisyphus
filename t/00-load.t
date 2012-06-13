#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'Sisyphus' ) || print "Bail out!\n";
    use_ok( 'Sisyphus::Testable' ) || print "Bail out!\n";
}

diag( "Testing Sisyphus $Sisyphus::VERSION, Perl $], $^X" );
