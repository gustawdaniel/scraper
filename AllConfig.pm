use strict;
use warnings FATAL => 'all';

package AllConfig;

#sub new { return bless {start=>4000000,limit=>1000000,rows=>'.layout'}, shift; }
sub new { return bless {start=>1,limit=>1000000,rows=>'.layout'}, shift; }

sub source { # arg index
    return "http://allegro.pl/listing/user/listing.php?us_id=".($_[1]+$_[0]->{start});
}

sub index {
    return ($_[1] =~ /=(\d+)/)[0];
}

sub invalid { # arg html
    return $_[1] =~ /<h2>Nic tu nie ma<\/h2>|<h2>Coś poszło nie tak<\h2>/ || $_[2] != 200;
}

sub optimal_select {

    open my $fh, '<', $_[1]
        or die("Unable to open file \"$_[1]\": $!\n");


    my $name;
    my $offers;
    my $additional;

    while (<$fh>) {
        if ($.>=615 || $.<=640) {
            ($_) = ($_ =~ /<h1 class="user-info">(.*)<\/h1>/);
            if($_) {
                $_ =~ s/<.*?>//g;
                ($name,$offers,$additional) = ($_ =~ /(?:Użytkownik)?(.*)\s+\(((?:\d+)?(?:\s)?\d+) ofert.?\)(.*)/);

                if (!(defined $offers)) {
                    warn "file: $_[1]";
                    warn "line: $.";
                    warn "text: $_";
                    die;
                }
#                warn "text: $_";

                $name =~ s/Użytkownik\s+|^\s+|\s+$//g;
                $additional =~ s/^\s+|\s+$//g;
                $offers =~ s/\s+//g;

                last;
            }
            last if($.>=640);
        }
    }

    close $fh;

    return (
        'name'       => $name,
        'offers'     => $offers,
        'additional' => $additional
    );

}

1;