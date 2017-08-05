#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

use HTML::Query 'Query';
use JSON;
use Loader;

my $config = Loader->load();
my @instances = ();

for(my $i = 0; $i<=$config->{limit}; $i++) {

    if (! -f 'raw/'.$config->{name}."/".$i.".html") { next; }

    my $q = Query( file => 'raw/'.$config->{name}."/".$i.".html" );
    my @rows = $q->query($config->{rows})->get_elements(); #

    foreach my $row (@rows)
    {
        $q = Query( tree => $row );
        my %object = $config->select($q);
        push @instances, \%object;
    }
}

print JSON->new->utf8(0)->encode(
    {
        'instances'=> \@instances
    }
);