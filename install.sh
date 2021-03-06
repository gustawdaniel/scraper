#!/usr/bin/env bash

# git clone https://github.com/gustawdaniel/scraper.git && cd scraper

# find raw/all/ -path '*/.*' -prune -o -type f -print | head -n 10 |  xargs -I {} du {} | awk '{sum+=$1} END {print sum}'

sudo apt-get update
sudo apt install sqlite3 libcurl4-gnutls-dev pkg-config pbzip2 pv  -y

export PERL_MM_USE_DEFAULT=1
cpan install Net::Curl::Easy Net::Curl::Multi DBD::SQLite MongoDB

bash db.sh

cd /usr/bin
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox
chmod +x dropbox
cd -

dropbox
#ls raw/all | head -n 1
# time tar -cf res/all_0.tar.bz2 --use-compress-prog=pbzip2 raw/all/

# rsync -r --info=progress2 raw/all.bak/all/ raw/all

# ./dropbox_uploader.sh upload scraper/res/all_1.tar.bz2 "/Folder zespołu hossa/res/all_1.tar.bz2"
# ./dropbox_uploader.sh upload scraper/res/errors.txt.new "/Folder zespołu hossa/res/errors_11.txt"

# old version of logs
# cat res/errors.txt | perl -lane 'print "$F[1],$F[4]"' | cat > res/errors.txt.new

# unpack
# time tar -I lbzip2 -xf res/all_0.tar.bz2 raw/all_0

# copy nth files
#
# mkdir -p raw/test_all_1000 && find raw/all -maxdepth 1 -type f | head -1000| xargs │ cp -t raw/test_all_1000