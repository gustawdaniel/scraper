#! /bin/bash

path='../raw/all';
limit="$1";

rm -Rf in;
rm -Rf out;
rm -Rf test;

mkdir in;
mkdir out;
mkdir test;

ls -1 $path | shuf | head -n "$limit" | xargs -d "\n" -I '%name%' mv  "$path/%name%" "in/%name%"

time python compress.py   dict in  out;

time python decompress.py dict out test;

du -h dict;
du -h in;
du -h out;
du -h test;

diff -qr in test;

