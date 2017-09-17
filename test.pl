#!/usr/bin/env perl
BEGIN {push @INC, 'lib'}
use strict;
use warnings FATAL => 'all';
use Try::Tiny;
use Loader;
use Compressor;
use JSON;

my $config = Loader->load(0);
my $cmp = Compressor->new();


foreach my $file (glob qq("dict/*.txt")) {
    my $content;
    open(my $fh, '<', $file) or die "cannot open file $file";
    {
        local $/;
        $content = <$fh>;
    }
    close($fh);

    $cmp->removeFromDict($cmp->path_to_int($file));
    $cmp->addToDict($cmp->path_to_int($file),$content);
}



my $i = 0;
my $counter = 0;

#print JSON->new->utf8(0)->encode(
#    {
#        'dict'=> $cmp->{dict}
#    }
#);


foreach my $file (glob qq("raw/$config->{name}/*.html")) {
    $counter += $cmp->count($file,$cmp->{dict}{3389});
    last if(++$i >= 200);
}

print "Files:  ".$i."\n";
print "Counts: ".$counter."\n";
print "Ratio: ".( try {$counter/$i} catch{ 0 } )."\n";

#print $cmp->path_to_code("dict/3328.txt") . "\n";
#print $cmp->code_to_path("ഀ"). "\n";