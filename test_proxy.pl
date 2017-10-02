#!/usr/bin/env perl
BEGIN {push @INC, 'lib'}

use strict;
use warnings FATAL => 'all';
use Net::Curl::Easy  qw( :constants );
use Net::Curl::Multi qw( );

use Loader;

my $max_running = 7;

sub make_request {
    my ( $url ) = @_;
    my $easy = Net::Curl::Easy->new();
    $easy->{url} = $url;
    $easy->setopt( CURLOPT_URL,        $url );
    $easy->setopt( CURLOPT_HEADERDATA, \$easy->{head} );
    $easy->setopt( CURLOPT_FILE,       \$easy->{body} );
    $easy->setopt( CURLOPT_PROXY, '91.135.216.51:53281');
    return $easy;
}


my $multi = Net::Curl::Multi->new();
my $running = 0;

my $e = 0;
my $s = 0;
my $i = 0;

while (1) {
    while ($i<10 && $running < $max_running ) {
        my $easy = make_request( "http://ipinfo.io/ip" );
        $multi->add_handle( $easy );
        ++$running;
        $i++;
    }

    last if !$running;

    my ( $r, $w, $ee ) = $multi->fdset();
    my $timeout = $multi->timeout();
    select( $r, $w, $ee, $timeout / 1000 )
        if $timeout > 0;

    $running = $multi->perform();
    while ( my ( $msg, $easy, $result ) = $multi->info_read() ) {
        $multi->remove_handle( $easy );

        print ($easy->{body});

        printf("\e[32mSUC %s\e[0m - [e: %s, s: %s]\n",$easy->getinfo( CURLINFO_RESPONSE_CODE ),$e,++$s);
    }
}




#91.135.216.51:53281