use strict;
use warnings FATAL => 'all';

package AllConfig;

sub new { return bless {limit=>47000000,rows=>'.layout'}, shift; }

sub source { # arg index
    return "http://allegro.pl/listing/user/listing.php?us_id=".$_[1];
}

sub invalid { # arg html
    return !$_[1];
}

sub select { # arg query
    my $q = $_[1];
    my ($name,$offers,$additional) = (($q->query('.user-info')->as_trimmed_text)[0] =~ /Użytkownik (.*) \((\d+) ofert\)\s*(.*)/);

    return (
        'name'       => $name,
        'offers'     => $offers,
        'additional' => $additional
    )
}

1;