use strict;
use warnings FATAL => 'all';

package Loader;

sub load
{
    if(defined $_[1] && $_[1] eq "rhf") {
        use RhfConfig;
        my $config = RhfConfig->new(1);
        $config->{name} = "rhf"; $config->{chunk} = "";  $config->{start} = 0;
        return $config;
    } elsif (defined $_[1] && $_[1] eq "spcc") {
        use SpccConfig;
        my $config = SpccConfig->new(1);
        $config->{name} = "spcc"; $config->{chunk} = ""; $config->{start} = 0;
        return $config;
    } elsif (defined $_[1] && $_[1] eq "ra") {
        use RaConfig;
        my $config = RaConfig->new(1);
        $config->{name} = "ra"; $config->{chunk} = ""; $config->{start} = 0;
        return $config;
    } elsif(defined $_[1] && int($_[1]) >= 0 && int($_[1]) < 47 ) {
        use AllConfig;
        my $config = AllConfig->new($_[1]);
        $config->{name} = "all";
        return $config;
    } else  {
        use Data::Dumper;
        print Dumper $_[1];
        die("\e[31mSet integer parameter with chunk number in proper (0-47) or rhf, spcc, ra\e[0m");
    }
}

sub load_errors
{
    my %err = ();
    open my $fh, "res/errors.txt" or return %err;
    while (<$fh>) {
        chomp;
        my ($word1, $word2) = split /,/;
        $err{$word1} = $word2;
    }
    close $fh;
    return %err;
}

1;