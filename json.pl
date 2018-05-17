#!/usr/bin/env perl
#use strict;
#use warnings FATAL => 'all';

no warnings qw(once);

require HTML::Query; #  'Query'


#our ($HTML::Query::EXPORT_ALL);

#{
#    no warnings 'once';
#    $Badger::WARN = 0;
#}
#
#require HTML::Query;
#{
#    no warnings 'once';
#    $HTML::Query::WARN = 0;
#}

use JSON;

#{
#
#no warnings 'once';
#$Badger::Utils::WARN = 0;
#$HTML::Query::WARN = 0;
#$Badger::Rainbow::WARN = 0;
#$Badger::Constants::WARN = 0;
#$Badger::WARN = 0;
#$Badger::Class::WARN = 0;
#
#}

use File::Basename;
use lib dirname (__FILE__);

use Loader;

my $config = Loader->load('ra');
my @instances = ();

my $i = 0;

foreach my $file (glob qq("raw/$config->{name}/*.html")) {
#    print  . "\n";
#    if (! -f 'raw/'.$config->{name}."/".$i.".html") { next; }

    my $q = HTML::Query->new( file => $file );
    my @rows = $q->query($config->{rows})->get_elements(); #

    foreach my $row (@rows)
    {
        $q = HTML::Query->new( tree => $row );
        my %object = $config->optimal_select($q);
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


