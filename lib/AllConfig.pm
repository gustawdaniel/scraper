use strict;
use warnings FATAL => 'all';

use JSON;

package AllConfig;

sub new { return bless {start=>$_[1]*1e6,limit=>1000000,rows=>'.layout','chunk'=>$_[1]}, shift; }

sub source { # arg index
    return "http://allegro.pl/listing/user/listing.php?us_id=".($_[1]+$_[0]->{start});
}

sub index {
    return ($_[1] =~ /=(\d+)/)[0];
}

sub invalid { # arg html
    return !defined $_[1] || $_[1] =~ /<h2>Nic tu nie ma<\/h2>|<h2>Coś poszło nie tak<\h2>/ || $_[2] != 200;
}

sub optimal_select {

    open my $fh, '<', $_[1]
        or die("Unable to open file \"$_[1]\": $!\n");


    my $name;
    my $offers;
    my $additional;
    my %data;

    while (<$fh>) {
        if ($.>=615 && $.<=640) {
            my ($content) = ($_ =~ /<h1 class="user-info">(.*?)<\/h1>/);
            if($content) {
                $content =~ s/<.*?>//g;
                ($name,$offers,$additional) = ($content =~ /(?:Użytkownik)?(.*)\s+\(((?:\d+)?(?:\s)?\d+) ofert.?\)(.*)/);

                if (!(defined $offers)) {
                    warn "file: $_[1]";
                    warn "line: $.";
                    warn "text: $content";
                    die;
                }
#                warn "text: $_";

                $name =~ s/Użytkownik\s+|^\s+|\s+$//g;
                $additional =~ s/^\s+|\s+$//g;
                $offers =~ s/\s+//g;

                last if $offers==0;
            }
            last if ($.>=640 && defined $offers && $offers==0);
        }

        if($.>=615) {
            if(/window\.__listing_CategoryTreeState/) {
#                print "$_\n";
                my ($json) = ($_ =~ /window\.__listing_CategoryTreeState = (.*?); /);
                $json =~ s/\"(\d+)\"/$1/g;

#                print $json;
#                die;

                my @data = JSON->new->utf8(0)->decode($json);
                unshift @data, 'category';
                %data = @data;


#                print JSON->new->utf8(0)->encode(\%data);
#                die;
            }
        }
    }

    close $fh;

    my %res = (
        'name'       => $name,
        'offers'     => defined $offers ? int $offers: -1,
        'additional' => $additional
    );

    %res = (%res,%data ) if %data;

    return %res;

}

1;