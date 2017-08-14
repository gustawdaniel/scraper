#!/usr/bin/env bash

# git clone https://github.com/gustawdaniel/scraper.git
#cd scraper

sudo apt-get update
sudo apt install sqlite3

mkdir res
bash db.sh

apt install cpanminus -y

sudo apt install libcurl4-gnutls-dev pkg-config -y

cpan install Net::Curl::Easy
cpan install Net::Curl::Multi
cpan install DBD::SQLite