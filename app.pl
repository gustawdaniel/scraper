#!/usr/bin/env perl
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
    return $easy;
}

my $config = Loader->load();
my %err = Loader->load_errors();

my $multi = Net::Curl::Multi->new();
my $running = 0;

my $e = 0;
my $s = 0;
my $i = 0;
mkdir 'raw', 0755;
mkdir 'raw/'.$config->{name}, 0755;

open(my $log, ">>res/errors.txt") or die "Cannot open file";
$SIG{INT} = sub { close($log); die "Caught a sigint $!" };

while (1) {
    while ($i<$config->{limit} && $running < $max_running ) {
        if (!(-f "raw/".$config->{name}."/".($i+$config->{start}).".html") && (! defined $err{$i+$config->{start}} || $err{$i+$config->{start}} != 404)) {
            my $easy = make_request( $config->source($i) );
            $multi->add_handle( $easy );
            ++$running;
        }
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
            printf("ID: %s - \e[31mERR %s\e[0m - [e: %s, s: %s]\n",$index,$easy->getinfo( CURLINFO_RESPONSE_CODE ),++$e,$s);
            printf($log "%s,%s\n",$index,$easy->getinfo( CURLINFO_RESPONSE_CODE ));
            next;
        }

        open(my $fh, '>', "raw/".$config->{name}."/".$index.".html") or die "Could not open file: $!";
        print $fh ($easy->{body});
        close $fh;

        printf("ID: %s - \e[32mSUC %s\e[0m - [e: %s, s: %s]\n",$index,$easy->getinfo( CURLINFO_RESPONSE_CODE ),$e,++$s);
    }
}

close($log);