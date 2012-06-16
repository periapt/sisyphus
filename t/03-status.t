#! /usr/bin/perl  

use Test::More tests => 8;
use File::Temp;
use Test::File;
use Sisyphus::Status;

my $newdir = File::Temp->newdir;
my $filename = $newdir->dirname . "/sisyphus-state";
my $status = Sisyphus::Status->new(filename=>$filename);
isa_ok($status, 'Sisyphus::Status');
is($status->filename, $filename, $filename);
file_not_exists_ok("$filename.dir");
file_not_exists_ok("$filename.pag");
is($status->get_status('hello world'), 'UNTRIED', 'state[hello world]==UNTRIED');
file_exists_ok("$filename.dir");
file_exists_ok("$filename.pag");
$status->set_status('hello world','PASS');
is($status->get_status('hello world'), 'PASS', 'state[hello world]==PASS');
