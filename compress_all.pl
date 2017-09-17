#!/usr/bin/env perl
BEGIN {push @INC, 'lib'}

use strict;
use warnings FATAL => 'all';
use Compressor;
use Loader;
use Parallel::ForkManager;

my $pm = Parallel::ForkManager->new(7);

my $config = Loader->load(0);
my $cmp = Compressor->new();

my $i = 0;
my @files = ();
my $content = "";
my $nr = "200";
mkdir "raw/cmp_$nr", 0755;

#foreach my $file (glob qq("raw/$config->{name}_$nr/*.html")) {
foreach my $file (glob qq("raw/all_$nr/*.html")) {
    push @{$files[$i%7]}, $file;
    last if(++$i >= 200000);
}

for my $list (@files) {
    my $pid = $pm->start and next;

    for my $file (@$list) {

        open(my $res, '<', $file) or die "Could not open file with html: $file - $!";
        {
            local $/;
            $content = <$res>;
        }
        close $res;
        unlink $file;
        $file =~ s/all/cmp/g;
        open(my $ret, '>', $file) or die "Could not open file to compress: $file - $!";
        print $ret ($cmp->compress($content));
        close $ret;

    }

    $pm->finish; # Terminates the child process
}
$pm->wait_all_children;


