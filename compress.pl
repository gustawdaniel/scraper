#!/usr/bin/env perl
BEGIN {push @INC, 'lib'}

use strict;
use warnings FATAL => 'all';
use Compressor;


my $cmp = Compressor->new();

my $content = "";
{
    local $/;
    $content = <>;
}

print $cmp->compress($content);
