#!/usr/bin/env bash

# git clone https://github.com/gustawdaniel/scraper.git && cd scraper
#

# find raw/all/ -path '*/.*' -prune -o -type f -print | head -n 10 |  xargs -I {} du {} | awk '{sum+=$1} END {print sum}'


sudo apt-get update
sudo apt install sqlite3 libcurl4-gnutls-dev pkg-config -y

export PERL_MM_USE_DEFAULT=1
cpan install Net::Curl::Easy Net::Curl::Multi DBD::SQLite

bash db.sh

# sudo apt install pbzip2

# time tar -cf res/all_100000.tar.bz2 --use-compress-prog=pbzip2 raw/all_100000/

# rsync -r --info=progress2 raw/all.bak/all/ raw/all