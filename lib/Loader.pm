use strict;
use warnings FATAL => 'all';

package Loader;

sub load
{
    if(scalar $_[1] && $_[1] eq "rhf") {
        use RhfConfig;
        my $config = RhfConfig->new(1);
        $config->{name} = "rhf";
        return $config;
    } elsif (scalar $_[1] && $_[1] eq "spcc") {
        use SpccConfig;
        my $config = SpccConfig->new(1);
        $config->{name} = "spcc";
        return $config;
    } elsif (scalar $_[1] && $_[1] eq "ra") {
        use RaConfig;
        my $config = RaConfig->new(1);
        $config->{name} = "ra";
        return $config;
    } elsif(defined $_[1] && int($_[1]) >= 0 && int($_[1]) < 47 ) {
        use AllConfig;
        my $config = AllConfig->new($_[1]);
        $config->{name} = "all";
        return $config;
    } else  {
#        use Data::Dumper;
#        print Dumper $_[1];
        print("\e[31mSet integer parameter with chunk number in proper range (0-47)\e[0m\n");
        exit;
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