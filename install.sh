#!/usr/bin/env bash

# git clone https://github.com/gustawdaniel/scraper.git && cd scraper
#

# find raw/all/ -path '*/.*' -prune -o -type f -print | head -n 10 |  xargs -I {} du {} | awk '{sum+=$1} END {print sum}'


sudo apt-get update
sudo apt install sqlite3 libcurl4-gnutls-dev pkg-config -y

cpan install Net::Curl::Easy Net::Curl::Multi DBD::SQLite

bash db.sh
