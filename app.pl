#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';
#use LWP::Simple;
use Net::Curl::Easy  qw( :constants );
use Net::Curl::Multi qw( );
#use Try::Tiny;

use Loader;


sub make_request {
    my ( $url ) = @_;
    my $easy = Net::Curl::Easy->new();
    $easy->{url} = $url;
    $easy->setopt( CURLOPT_URL,        $url );
    $easy->setopt( CURLOPT_HEADERDATA, \$easy->{head} );
    $easy->setopt( CURLOPT_FILE,       \$easy->{body} );
    return $easy;
}

my $config = Loader->load();

my $max_running = 7;
my $multi = Net::Curl::Multi->new();
my $running = 0;

my $e = 0;
my $s = 0;
my $i = 0;
mkdir 'raw', 0755;
mkdir 'raw/'.$config->{name}, 0755;

open(my $log, ">>res/errors.txt") or die "Cannot open file";

while (1) {
    while ($i<$config->{limit} && $running < $max_running ) {
        my $easy = make_request( $config->source($i) );
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

        my $index = $config->index($easy->{url});

        if ($config->invalid($easy->{body},$easy->getinfo( CURLINFO_RESPONSE_CODE )))
        {
            printf("ID:\t%s - \e[31mERROR   %s\e[0m - [e: %s, s: %s] %s\n",$index,$easy->getinfo( CURLINFO_RESPONSE_CODE ),++$e,$s,$easy->{url});
            printf($log "ID:\t%s - \e[31mERROR   %s\e[0m - [e: %s, s: %s] %s\n",$index,$easy->getinfo( CURLINFO_RESPONSE_CODE ),$e,$s,$easy->{url});
            next;
        }

#        my ($str) = ($easy->{body} =~ /<title>(.*)<\/title>/);
#
#        print $str . "\n";
#        die;

        open(my $fh, '>', "raw/".$config->{name}."/".$index.".html") or die "Could not open file: $!";
        print $fh ($easy->{body});
        close $fh;

        printf("ID:\t%s - \e[32mSUCCESS %s\e[0m - [e: %s, s: %s] %s\n",$index,$easy->getinfo( CURLINFO_RESPONSE_CODE ),$e,++$s,$easy->{url});
    }
}

close($log);