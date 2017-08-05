#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';
use LWP::Simple;
use open ':std', ':encoding(UTF-8)';
use Loader;

my $config = Loader->load();

my $e = 0;
my $s = 0;
mkdir 'raw', 0755;
mkdir 'raw/'.$config->{name}, 0755;

for(my $i = 0; $i<=$config->{limit}; $i++) {

    my $html = get $config->source($i);

    if ($config->invalid($html))
    {
        print "ID:\t" . $i . " - \e[31mERROR\e[0m - [e: ".++$e.", s: $s]\n";
        next;
    }

    open(my $fh, '>', "raw/".$config->{name}."/".$i.".html") or die "Could not open file: $!";
    print $fh ($html);
    close $fh;

    $s++;
    print "ID:\t" . $i . " - \e[32mSUCCESS\e[0m - [e: $e, s: $s]\n";
}

