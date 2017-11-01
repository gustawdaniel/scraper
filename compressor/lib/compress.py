#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Funkcja kompresujaca dane.
def compress(dict, data):
	
	data  = data.decode('utf8').encode('unicode-escape');
	
	for item in dict:
		tag  = item['tag'];
		word = item['word'];
		data = data.replace(word, tag);
	
	return data;

# Funkcja dekompresujaca dane.
def decompress(dict, data):
	
	for item in reversed(dict):
		tag  = item['tag'];
		word = item['word'];
		data = data.replace(tag, word);
	
	data = data.decode('unicode-escape').encode('utf8');
	
	return data;

