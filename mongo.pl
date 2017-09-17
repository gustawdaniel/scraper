#!/usr/bin/env perl
BEGIN {push @INC, 'lib'}
use strict;
use warnings FATAL => 'all';

# cpan App::cpanminus:
# cpanm MongoDB --force

use MongoDB;
use JSON;


use Loader;
use Parallel::ForkManager;

my $pm = Parallel::ForkManager->new(7);

my $config = Loader->load(0);
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
        );
    }

    $pm->finish; # Terminates the child process
}
$pm->wait_all_children;

#print JSON->new->utf8(0)->encode(
#    {
#        'instances'=> \@instances
#    }
#);
