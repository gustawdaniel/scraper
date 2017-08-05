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
    } else {
        use RaConfig;
        my $config = RaConfig->new();
        $config->{name} = "ra";
        return $config;
    }
}

1;