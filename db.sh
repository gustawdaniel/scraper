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