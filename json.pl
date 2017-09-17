#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

use HTML::Query 'Query';
use JSON;
use Loader;

my $config = Loader->load();
my @instances = ();

my $i = 0;

foreach my $file (glob qq("raw/$config->{name}/*.html")) {
#    print  . "\n";
#    if (! -f 'raw/'.$config->{name}."/".$i.".html") { next; }

    my $q = Query( file => $file );
    my @rows = $q->query($config->{rows})->get_elements(); #

    foreach my $row (@rows)
    {
        $q = Query( tree => $row );
        my %object = $config->select($q);
        $object{'created_at'} = (stat $file)[9];
        push @instances, \%object;
    }

    last if(++$i >= 5);
}

print JSON->new->utf8(0)->encode(
    {
        'instances'=> \@instances
    }
);


