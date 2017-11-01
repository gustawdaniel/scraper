#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import random

execfile("lib/dict.py");
execfile("lib/compress.py");
execfile("lib/samples.py");
execfile("lib/lcs.py");

# Parametry skryptu:
samples_num  =   12; # 12;      # Ilosc plikow brana do prubkowania.
samples_path = '../raw/all';    # Sciezka do katalogu z probkami.
dict_min     =   20;            # Minimalna dopuszczalna wielkosc wpisu w slowniku przy budowaniu.
dict_max     =  100;            # Maksymalna dopuszczalna ilosc wpisow w slowniku przy budowaniu.
dict_path    = 'dict';          # Sciezka do katalogu ze slownikiem.
dict_pattern = '@%02x';         # Wzor na ktorym zostaje zastapiony wpis w slowniku (starczy na 255 wpisow).
dict_first   = "@";             # Pierwszy wpis w slowniku, ktory jest ucieczka przed aktualnym wzorem.

# Zmienne pomocnicze.
dict = dict_init(dict_path,dict_pattern);
dict = dict_add (dict_path,dict_first);
num  = 0;

# Petla glowna.
while True:
	# Wczytywanie prubek plików w których będzie wyszukiwane nowe słowo.
	print '################ SAMPLES';
	samples = samples_read(samples_path, samples_num);
	files   = [s['file'] for s in samples];
	sizesum = sum(map(len,files));
	
	for s in samples:
		print "\t" + s['name'] + "\t" + str(s['size']);
	
	# Kompresowanie plików aktualnym słownikiem.
	print '################ COMPRESS';
	for key,file in enumerate(files):
		files[key] = compress(dict,file);
	
	print 'sum  = %d' % sizesum;
	print 'comp = %f' % (float(sum(map(len,files)))/sizesum);
	
	if num >= dict_max:
		break;
	
	# Szukanie najdłóższego wspólnego podciągu.
	print '################ LCS';
	word = lcs(files);
	size = len(word);
	num  = num + 1;
	
	# Wypisywanie informacji o znalezionym podciągu.
	print '################ INFO';
	print 'num  = %d' % num;
	print 'size = %d' % size;
	
	if size < dict_min:
		break;
	
	# Dodawanie podciągu do słownika.
	print '################ ADD';
	dict = dict_add(dict_path,word);

