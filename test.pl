#!/usr/bin/env perl

#require HTML::Query;
use Mojo::DOM;
use JSON;
use open ':encoding(UTF-8)';
use Data::Dumper;

my $contents = do { local(@ARGV, $/) = 'raw/bazalekow/medicine/4244.html'; <> };

my %data = ();

$contents =~ s/(<tbody>.*<\/tbody>)/$data{'part'}=$1;/egs;


my $dom = Mojo::DOM->new($data{part});

#print $contents."\n";

#my $q = HTML::Query->new( text => $data{'part'} );

my $trs = Mojo::DOM->new($dom->at('tbody')->content)->find('tr:not([style])');
my @arr = ();

foreach my $tr ($trs->each) {

#print Dumper $tr;

    my @tds = Mojo::DOM->new($tr->content)->find('td')->each;

    my %hash = (
        'name' => @tds[0]->text,
        'character' => @tds[1]->text =~ /(.*?);.*/s,
        'dose' => @tds[1]->text =~ /.*;\s*(.*?)\s*;.*/s,
        'package' => @tds[1]->text =~ /.*;(.*?)/s,
        'manufacturer' => @tds[2]->text,
        'price' => @tds[3]->text,
        'price_after_refund' => @tds[4]->text =~ /[\r\n\s]+(.*)[\r\n\s]+/sg,
        'pharmacy' => @tds[5]->text =~ /[\r\n\s]+(.*)[\r\n\s]+/sg
    );
    push @arr, \%hash;
}

%data = (
    %data,
#    tr => $q->query('tr')->first->as_trimmed_text,
    character => \@arr,
#    html => $q->as_HTML
);

print JSON->new->utf8(0)->encode( \%data );

#print $data{part};
#
#print "\n" . "-" x 80 . "\n";


#print $dom->find('tbody>tr:not([style])')->map('content')->join("\n" . "=" x 80 . "\n");

#print $data{part};

#sub optimal_select { # arg query
##
##    print $_[1];
#
#    my $q = HTML::Query->new( file => $_[1] );
#
#    my %hash;
#    @hash{$q->query('.inputArea.full h3')->as_trimmed_text} = $q->query('.inputArea.full span')->as_trimmed_text;
#    return %hash;
#}
#
#print JSON->new->utf8(0)->encode(
#    {
#        'instances'=> \optimal_select("raw/ra/1.html")
#    }
#);

#use strict;
#use Loader;
#use JSON;
#
#my $config = Loader->load();
#
#open my $fh, "res/errors.txt" or die;
#my %err;
#while (<$fh>) {
#    chomp;
#    my ($word1, $word2) = split /,/;
#    $err{$word1} = $word2;
#}
#
#use Data::Dumper;
#print Dumper \%err;
#
#if($err{20027491+2} == 404) {
#    print "ok\n";
#}
#
#if($err{20027491} == 404) {
#    print "ok\n";
#}


#my @instances = ();
#my %object = $config->optimal_select("raw/all/10018.html");
#push @instances,\%object;
#my %object2 = $config->optimal_select("raw/all/1680.html");
#push @instances,\%object2;
#my %object3 = $config->optimal_select("raw/all/216.html");
#push @instances,\%object3;
#
#print JSON->new->utf8(0)->encode(
#    {
#        'instances'=> \@instances
#    }
#);


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

