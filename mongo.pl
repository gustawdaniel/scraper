#!/usr/bin/env perl
use strict;

# usage
# perl mongo.pl ra

# cpan App::cpanminus:
# cpanm MongoDB --force
use warnings FATAL => 'all';


use MongoDB;
use JSON;


use Parallel::ForkManager;

use File::Basename;
use lib dirname (__FILE__);

use Loader;

my $pm = Parallel::ForkManager->new(7);

my $config = Loader->load($ARGV[0]);
my $client = MongoDB->connect();
my $coll = $client->ns("all.users");

my $i = 0;

my @files = ();

foreach my $file (glob qq("raw/$config->{name}/*.html")) {

    push @{$files[$i%7]}, $file;

    last if(++$i >= 200000);
}

for my $list (@files) {
    my $pid = $pm->start and next;

    for my $file (@$list) {

        my %object = $config->optimal_select($file);
        $object{'created_at'} = (stat $file)[9];
        $object{'size'} = (stat $file)[7];
        ($object{'_id'}) = map { int } ( $file =~ /(\d+)\.html/);

        next if defined( $coll->find_one( { _id => $object{'_id'} } ) );

        $coll->insert_one(
            \%object
#                    { safe => 1 }
        );
    }

    $pm->finish; # Terminates the child process
}
$pm->wait_all_children;
#
#

#
#

#print JSON->new->utf8(0)->encode(
#    {
#        'instances'=> \@instances
#    }
#);


#0
#1
#2
#3
#4
#5
#6
#7
#8
#9
#10
#11
#12
#13
#14
#    15
#    16
#17
#18
#19
#   20
#   21
#                      22
#   23
#   24
#25
#26
#27
#28
#29
#30
#40
#41
#42
#43
#44
