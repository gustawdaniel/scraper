#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

use DBI;
use Loader;

my $config = Loader->load();

my $i = 0;

my $dbh = DBI->connect(
    "dbi:SQLite:res/all.db", "", "",
    {
        RaiseError => 1, AutoCommit => 0
    }
);

$dbh->do("DELETE FROM log");

my $sth = $dbh->prepare(<<'SQL');
INSERT INTO log
       (id,   name,  offers, additional, created_at, size)
VALUES ( ?,      ?,       ?,          ?,          ?,    ?)
SQL

foreach my $file (glob qq("raw/$config->{name}/*.html")) {

    print $file =~ /(\d+)\.html/, "\n";

    my %object = $config->optimal_select($file);
    $object{'created_at'} = (stat $file)[9];
    $object{'size'} = (stat $file)[7];
    ($object{'id'}) = ($file =~ /(\d+)\.html/);
#        print $object{id}."\n";

#        last;

    $sth->execute((
        $object{'id'},
        $object{'name'},
        $object{'offers'},
        $object{'additional'},
        $object{'created_at'},
        $object{'size'}
    ));

    last if(++$i >= 5000);
}

$sth->finish;
$dbh->commit;