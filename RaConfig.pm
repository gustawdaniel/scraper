use strict;
use warnings FATAL => 'all';

package RaConfig;

sub new { return bless {limit=>22300,rows=>'.pharmacyDetailsControl_Div.controlContainer'}, shift; }

sub source { # arg index
    return "http://ra.rejestrymedyczne.csioz.gov.pl/_layouts/15/RA/PharmacyDetailsPublic.aspx?id=".$_[1]."&IsDlg=1";
}

sub invalid { # arg html
    return $_[1] =~ /ctl00_PlaceHolderPageTitleInTitleArea_ErrorPageTitlePanel/;
}

sub select { # arg query
    my %hash;
    @hash{$_[1]->query('.inputArea.full h3')->as_trimmed_text} = $_[1]->query('.inputArea.full span')->as_trimmed_text;
    return %hash;
}

1;