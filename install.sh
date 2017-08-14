#!/usr/bin/env bash

# git clone https://github.com/gustawdaniel/scraper.git
#cd scraper

# find raw/all/ -path '*/.*' -prune -o -type f -print | head -n 10 |  xargs -I {} du {} | awk '{sum+=$1} END {print sum}'


sudo apt-get update
sudo apt install sqlite3

mkdir res
bash db.sh

apt install cpanminus -y

sudo apt install libcurl4-gnutls-dev pkg-config -y

cpan install Net::Curl::Easy
cpan install Net::Curl::Multi
cpan install DBD::SQLite