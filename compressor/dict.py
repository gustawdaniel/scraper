#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import random

execfile("lib/dict.py");
execfile("lib/compress.py");
execfile("lib/samples.py");
execfile("lib/lcs.py");

# Parametry skryptu:
samples_num  =   2; # 12;                                            # Ilosc plikow brana do prubkowania.
samples_path = '/home/kot/Pulpit/daniel/scraper/raw/all';            # Sciezka do katalogu z probkami.
dict_min     =  20;                                                  # Minimalna dopuszczalna wielkosc wpisu w slowniku.
dict_max     =  10;                                                  # Maksymalna dopuszczalna ilosc wpisow w slowniku.
dict_path    = '/home/kot/Pulpit/daniel/scraper/compressor/dict';    # Sciezka do katalogu ze slownikiem.
pattern      = '[#]%s[#]';                                           # Wzor na ktorym zostaje zastapiony wpis w slowniku.

# Zmienne pomocnicze.
dict = dict_init(dict_path,pattern);
num  = 0;

# Petla glowna.
while True:
	print '################ SAMPLES';
	samples = samples_read(samples_path, samples_num);
	files   = [s['file'] for s in samples];
	sizesum = sum(map(len,files));
	
	for s in samples:
		print "\t" + s['name'] + "\t" + str(s['size']);
	
	print '################ COMPRESS';
	for key,file in enumerate(files):
		files[key] = compress(dict,file);
	
	print 'sum  = %d' % sizesum;
	print 'comp = %f' % (float(sum(map(len,files)))/sizesum);
	
	if num >= dict_max:
		break;
	
	print '################ LCS';
	word = lcs(files);
	size = len(word);
	num  = num + 1;
	
	print '################ INFO';
	print 'num  = %d' % num;
	print 'size = %d' % size;
	
	if size < dict_min:
		break;
	
	print '################ ADD';
	dict = dict_add(dict_path,dict,word);

