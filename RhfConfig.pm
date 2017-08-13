use strict;
use warnings FATAL => 'all';

package RhfConfig;

sub new { return bless {limit=>1000,rows=>'.pharmacyDetailsControl_Div.controlContainer'}, shift; }

sub source {
    return "http://rhf.rejestrymedyczne.csioz.gov.pl/_layouts/15/RHF/WarehouseDetailsPublic.aspx?id=".$_[1]."&IsDlg=1";
}

sub invalid {
    return $_[1] =~ /ctl00_PlaceHolderPageTitleInTitleArea_ErrorPageTitlePanel/;
}

sub select { # arg query
    my %hash;
    @hash{$_[1]->query('.inputArea.full h3')->as_trimmed_text} = $_[1]->query('.inputArea.full span')->as_trimmed_text;
    return %hash;
}

1;