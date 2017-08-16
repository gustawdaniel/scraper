#!/usr/bin/env bash

if [[ $# -eq 0 ]] ; then
    echo -e "\e[31mLack of number of processed M\e[0m";
    exit 0
fi

echo "Processing package $1";

cd "$(dirname "$0")"
tar cf - raw/all | pbzip2 -p$(grep -c ^processor /proc/cpuinfo) > res/all.tar.bz2

cd ..

./dropbox_uploader.sh upload scraper/res/errors.txt.new "/Folder zespołu hossa/res/errors_$1.txt";
./dropbox_uploader.sh upload scraper/res/all.tar.bz2 "/Folder zespołu hossa/res/all_$1.tar.bz2";

cd scraper

mv raw/all raw/all_$1
mv res/all.tar.bz2 res/all_$1.tar.bz2
mv res/errors.txt res/errors_$1.txt

# cd pro/maciej/hurt && source res/.alias && sh_