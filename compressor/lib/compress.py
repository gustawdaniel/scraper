#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Funkcja kompresujaca dane.
def compress(dict, data):
	
	for item in dict:
		tag  = item['tag'];
		word = item['word'];
		data = data.replace(word, tag);
		data = data.encode('ascii','ignore');
	
	return data;

# Funkcja dekompresujaca dane.
def decompress(dict, data):
	
	for item in reversed(dict):
		tag  = item['tag'];
		word = item['word'];
		data = data.replace(tag, word);
		data = data.encode('ascii','ignore');
	
	return data;

