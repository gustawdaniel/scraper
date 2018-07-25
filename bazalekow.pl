#!/usr/bin/env perl

# Get lists
use LWP::Simple;
use JSON;
use MongoDB;
use Mojo::DOM;

#use open ':encoding(UTF-8)';
#use open ':std', ':encoding(UTF-8)';

use utf8::all;

require HTML::Query; #  'Query'



my $client = MongoDB->connect();
my $coll = $client->ns("local.medicines");



# number of medicaments
#perl bazalekow.pl | jq '. | length'

my $dir = 'raw/bazalekow/index';

mkdir 'raw', 0755;
mkdir 'res', 0755;
mkdir 'raw/bazalekow', 0755;
mkdir $dir, 0755;
my @instances = ();

my $i=0;
foreach my $letter ('2','4','5','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','Ś','T','U','V','W','X','Y','Z','Ż') {

    my $file = $dir."/".$letter.".html";

    if(! -f $file) {
        $html = get('https://bazalekow.mp.pl/leki/items.html?letter='.$letter);

        open(my $fh, '>', $file) or die "Could not open file: $!";
        print $fh $html;
        close $fh;
    }

    my $contents = do { local(@ARGV, $/) = $file; <> };

    my $dom = Mojo::DOM->new($contents);

    my @rows = $dom->find('.drug-list a')->each;

    foreach my $row (@rows) {

        my %object = (
            'name' => $row->text,
            'link' => $row->attr('href')
        );
        push @instances, \%object;
    }

    print $i . "\t" .  $letter . "\t" . @rows . "\n";



#    last if $i >= 0;
    $i++;
}


#print JSON->new->utf8(0)->encode(
#    \@instances
#);
#die;

$dir = 'raw/bazalekow/medicine';
mkdir $dir, 0755;

open(my $log, ">>res/errors_baza_lekow.txt") or die "Cannot open file";

$i = -1;

print "---   ---   ---   ---   ---\n";

foreach my $object (@instances) {

    my $file = $dir."/".($i+1).".html";

    ($instances[($i+1)]{'_id'}) = map { int } ( $file =~ /(\d+)\.html/);

    next if defined( $coll->find_one( { _id => $instances[++$i]{'_id'} } ) );

    print $i . "\t" . (time() - $^T) . "\t" . $instances[$i]{link} . "\n";


    if(! -f $file) {
        $html = get($object->{link});

        open(my $fh, '>', $file) or die "Could not open file: $!";
        print $fh $html;
        close $fh;
    }

    # https://bazalekow.mp.pl/lek/94393,KiD-Vitum-150-µg-krople-wyciskane-z-kapsulki-twist-off

    my $q = HTML::Query->new( file => $file );

    my $area = $q->query('.drug-description');



    my $contents = do { local(@ARGV, $/) = $file; <> };

    my %data = ();

    $contents =~ s/(<tbody>.*<\/tbody>)/$data{'part'}=$1;/egs;

    if(!$data{part}){
        printf($log "%s,%s\n",$i,$instances[$i]{link});
        next;
    }

    my $dom = Mojo::DOM->new($data{part});

    my $trs = Mojo::DOM->new($dom->at('tbody')->content)->find('tr:not([style])');
    my @arr = ();

    foreach my $tr ($trs->each) {


        my @tds = Mojo::DOM->new($tr->content)->find('td')->each;

        my %hash = (
            'name' => @tds[0]->text,
            'character' => @tds[1]->text =~ /(.*?);.*/s,
            'dose' => @tds[1]->text =~ /.*;\s*(.*?)\s*;.*/s,
            'package' => @tds[1]->text =~ /.*;(.*?)/s,
            'manufacturer' => @tds[2]->text,
            'price' => @tds[3]->text,
            'price_after_refund' => @tds[4]->text =~ /[\r\n\s]+(.*)[\r\n\s]+/sg,
        );
        if(@tds[5]) {
            $hash{pharmacy} = $tds[5]->text =~ /[\r\n\s]+(.*)[\r\n\s]+/sg;
        }
        push @arr, \%hash;
    }


    $instances[$i]{characters} = \@arr;




#print JSON->new->utf8(0)->encode(
#    \%$object
#);
        $coll->insert_one(
            \%$object
#                    { safe => 1 }
        );


}


