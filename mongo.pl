use strict;

# cpan App::cpanminus:
# cpanm MongoDB --force

use MongoDB;
use JSON;

#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

#use DBI;
use Loader;
#use Parallel::ForkManager;
#
#my $pm = Parallel::ForkManager->new($MAX_PROCESSES);
#
#DATA_LOOP:
#foreach my $data (@all_data) {
#    # Forks and returns the pid for the child:
#    my $pid = $pm->start and next DATA_LOOP;
#
#    ... do some work with $data in the child process ...
#
#    $pm->finish; # Terminates the child process
#}

my $config = Loader->load(0);
my $client = MongoDB->connect();
my $coll = $client->ns("all.users");
my @instances = ();

my $i = 0;

foreach my $file (glob qq("raw/$config->{name}/*.html")) {

#    print $i ," | ", $file =~ /(\d+)\.html/, "\n" if !($i++%1000);

    my %object = $config->optimal_select($file);
    $object{'created_at'} = (stat $file)[9];
    $object{'size'} = (stat $file)[7];
    ($object{'_id'}) = map { int } ( $file =~ /(\d+)\.html/);

    last if(++$i >= 20000);

    next if defined( $coll->find_one( { _id => $object{'_id'} } ) );
#    print $object{_id}."\n";
#    push @instances, \%object;

    $coll->insert_one(
        \%object
#        { safe => 1 }
    );
}

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
