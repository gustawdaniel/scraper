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

    last if(++$i >= 500);

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
