use strict;
use warnings FATAL => 'all';

package Loader;

sub load
{
    if(scalar @ARGV && $ARGV[0] eq "rhf") {
        use RhfConfig;
        my $config = RhfConfig->new();
        $config->{name} = "rhf";
        return $config;
    } elsif (scalar @ARGV && $ARGV[0] eq "spcc") {
        use SpccConfig;
        my $config = SpccConfig->new();
        $config->{name} = "spcc";
        return $config;
    } elsif (scalar @ARGV && $ARGV[0] eq "ra") {
        use RaConfig;
        my $config = RaConfig->new();
        $config->{name} = "ra";
        return $config;
    } else {
        use AllConfig;
        my $config = AllConfig->new();
        $config->{name} = "all";
        return $config;
    }
}

sub load_errors
{
    open my $fh, "res/errors.txt" or die;
    my %err;
    while (<$fh>) {
        chomp;
        my ($word1, $word2) = split /,/;
        $err{$word1} = $word2;
    }
    return %err;
}

1;