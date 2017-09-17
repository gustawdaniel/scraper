#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use utf8;

binmode STDOUT, ":utf8";

# 3328
foreach my $i (3328..3400) {
    printf("dec: %5s hex: %x - |   %s   |\n",$i, $i, chr($i));
}
