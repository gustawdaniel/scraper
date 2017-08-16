#!/usr/bin/env bash

if [[ $# -eq 0 ]] ; then
    echo -e "\e[31mLack of number of processed M\e[0m";
    exit 0
fi

if [[ $1 == "do" && $2 -ge 0  ]] ; then

    echo "Processing package $2";

    cd "$(dirname "$0")"
    tar cf - raw/all_$2 | pv | pbzip2 -p$(grep -c ^processor /proc/cpuinfo) > res/all_$2.tar.bz2

    dropbox upload res/errors_$2.txt "/Folder zespołu hossa/res/errors_$2.txt";
    dropbox upload res/all_$2.tar.bz2 "/Folder zespołu hossa/res/all_$2.tar.bz2";

fi

if [[ $1 == "list" ]] ; then

    dropbox list "/Folder zespołu hossa/res/"

fi

if [[ $1 == "get" && $2 -ge 0 ]] ; then

    dropbox download "/Folder zespołu hossa/res/errors_"$2'.txt' 'res/errors_'$2'.txt'
    dropbox download "/Folder zespołu hossa/res/all_"$2'.tar.bz2' 'res/all_'$2'.tar.bz2'

fi

if [[ $1 == "files_implode" ]] ; then

    mkdir -p raw/all

    for f in raw/all_*; do
         echo "Processing $f catalog...";
         rsync -r --info=progress2 $f/ raw/all
    done

fi

