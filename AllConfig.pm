use strict;
use warnings FATAL => 'all';

package AllConfig;

sub new { return bless {limit=>47000000,rows=>'.layout'}, shift; }

sub source { # arg index
    return "http://allegro.pl/listing/user/listing.php?us_id=".$_[1];
}

sub index {
    return ($_[1] =~ /=(\d+)/)[0];
}

sub invalid { # arg html
    return $_[1] =~ /<h2>Nic tu nie ma<\/h2>/;
}

#sub select { # arg query
#    my $q = $_[1];
#    my ($name,$offers,$additional) = (($q->query('.user-info')->as_trimmed_text)[0] =~ /Użytkownik (.*) \(((\d+)?(\s+)?\d+) ofert\)\s*(.*)/);
#
#    return (
#        'name'       => $name,
#        'offers'     => $offers,
#        'additional' => $additional
#    )
#}

sub optimal_select {

    open my $fh, '<', $_[1]
        or die("Unable to open file \"$_[1]\": $!\n");


    my $name;
    my $offers;
    my $additional;

    while (<$fh>) {
        if ($.>=615 || $.<=618) {
            ($_) = ($_ =~ /<h1 class="user-info">(.*)<\/h1>/);
            if($_) {
                $_ =~ s/<.*?>//g;
                ($name,$offers,$additional) = ($_ =~ /Użytkownik (.*)\s+\(((\d+)?(\s)?\d+) ofert.?\)\s*(.*)/);
                $offers =~ s/\s+//g;
                last;
            }
            last if($.>=618);
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