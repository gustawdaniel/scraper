use strict;
use Loader;
use JSON;

my $config = Loader->load();

my @instances = ();
my %object = $config->optimal_select("raw/all/10018.html");
push @instances,\%object;
my %object2 = $config->optimal_select("raw/all/1680.html");
push @instances,\%object2;
my %object3 = $config->optimal_select("raw/all/216.html");
push @instances,\%object3;

print JSON->new->utf8(0)->encode(
    {
        'instances'=> \@instances
    }
);


#print $config->index("http://allegro.pl/listing/user/listing.php?us_id=7");

#use Net::Curl::Easy  qw( :constants );
#use Net::Curl::Multi qw( );
#
#sub make_request {
#    my ( $url ) = @_;
#    my $easy = Net::Curl::Easy->new();
#    $easy->{url} = $url;
#    $easy->setopt( CURLOPT_URL,        $url );
#    $easy->setopt( CURLOPT_HEADERDATA, \$easy->{head} );
#    $easy->setopt( CURLOPT_FILE,       \$easy->{body} );
#    return $easy;
#}
#
#
#my $max_running = 10;
#my $multi = Net::Curl::Multi->new();
#my $running = 0;
#
#while (1) {
#    while ($running < $max_running ) {
#        my $easy = make_request( "http://localhost:8000/test.html" );
#        $multi->add_handle( $easy );
#        ++$running;
#        last;
#    }
#
#    last if !$running;
#
#    my ( $r, $w, $ee ) = $multi->fdset();
#    my $timeout = $multi->timeout();
#    select( $r, $w, $ee, $timeout / 1000 )
#        if $timeout > 0;
#
#    $running = $multi->perform();
#    while ( my ( $msg, $easy, $result ) = $multi->info_read() ) {
#        $multi->remove_handle( $easy );
#
#        print $easy->{body};
#
#        last;
#    }
#}

