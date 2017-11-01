#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Funkcja kompresujaca dane.
def compress(dict, data):
	
	# Usuwanie z pliku utf8 i zastepowanie go ascii.
	data  = data.decode('utf8').encode('unicode-escape');
	
	# Kompresja slownikiem.
	for item in dict:
		tag  = item['tag'];
		word = item['word'];
		data = data.replace(word, tag);
	
	return data;

# Funkcja dekompresujaca dane.
def decompress(dict, data):
	
	# Dekompresja slownikiem.
	for item in reversed(dict):
		tag  = item['tag'];
		word = item['word'];
		data = data.replace(tag, word);
	
	# Zamiana znakow ucieczki w ascii na znaki w utf8.
	data = data.decode('unicode-escape').encode('utf8');
	
	return data;

