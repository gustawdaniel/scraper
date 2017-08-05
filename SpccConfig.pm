use strict;
use warnings FATAL => 'all';

package SpccConfig;

sub new { return bless {limit=>12,rows=>'td.col-1'}, shift; }

sub source {
    my $link = "https://www.spcc.pl/members/search/all/all/all";
    if($_[1]) { $link .= "?page=".$_[1]; }
    return $link;
}

sub invalid { return 0; }

sub select {
    my $q = $_[1];
    return (
        'name'       => $q->query('.members_search_title')->as_trimmed_text,
        'phone'      => $q->query('.views-field-field-telefon-value')->as_trimmed_text,
        'person'      => $q->query('.views-field-field-kontakt-osoba-value')->as_trimmed_text,
        'email'      => $q->query('.views-field-field-email-email')->as_trimmed_text,
        'www'      => $q->query('.views-field-field-www-url')->as_trimmed_text,
        'branches'     => $q->query('.views-field-phpcode-2')->as_trimmed_text
    )
}

1;