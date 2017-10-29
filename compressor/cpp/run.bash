#! /bin/bash

chmod +x "$(dirname "${BASH_SOURCE[0]}")/build/scraper-compressor";

list="$(ls -1 ../raw/all | sort | head -n "$1")";
in="$(echo "$list" | sed 's|^|../raw/all/|')";
out="$(echo "$list" | sed 's|^|out/|')";

"$(dirname "${BASH_SOURCE[0]}")/build/scraper-compressor" dict out $in;

wc -c $in;
wc -c $out;

