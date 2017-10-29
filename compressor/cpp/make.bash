#! /bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")";

rm -Rf 'build';
mkdir  'build';
cd     'build';

cmake  '..';
make;

