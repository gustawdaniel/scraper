#!/usr/bin/env bash

mkdir -p res

sqlite3 res/all.db \
"drop table IF EXISTS log;"

sqlite3 res/all.db \
"create table IF NOT EXISTS log (
    id          INTEGER PRIMARY KEY,
    name        VARCHAR(255),
    offers      UNSIGNED INTEGER,
    additional  VARCHAR(255),
    created_at  UNSIGNED INTEGER,
    size        UNSIGNED INTEGER
);"

sqlite3 res/all.db \
"drop table IF EXISTS dict;"

sqlite3 res/all.db \
"create table IF NOT EXISTS dict (
    id          VARCHAR(20) PRIMARY KEY,
    val         TEXT
);"

#for f in dict/*.txt; do
#    id=$(basename ${f} | cut -f 1 -d '.');
#    text=$(cat ${f});
#    echo "${id}";
#    sqlite3 res/all.db "INSERT INTO dict (id, val) VALUES ($id, \"$text\")"
#done