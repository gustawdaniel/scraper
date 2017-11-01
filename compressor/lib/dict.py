#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Do operacji na plikach.
import os;

# Inicjalizowanie slownika.
def dict_init(dir,pattern):
	
	# Czyszczenie starych slow ze slownika.
	for name in os.listdir(dir):
		path = os.path.join(dir, name);
		os.unlink(path);
	
	# Zapisywanie nowego wzorca tagu.
	path = os.path.join(dir,'-1');
	file = open(path,"w");
	file.write(pattern);
	file.close();
	
	# Zwracanie czystego slownika.
	return [];

# Dodawanie slowa do slownika.
def dict_add(dir,word):
	
	# Zapisywanie nowego slowa.
	key  = len(os.listdir(dir))-1;
	path = os.path.join(dir,str(key));
	file = open(path,"w"); 
	file.write(word);
	file.close();
	
	# Zwracanie rozszerzonego slownika.
	return dict_load(dir);

# Wczytywanie slownika.
def dict_load(dir):
	
	# Wczytywanie wzorca tagu.
	path    = os.path.join(dir,'-1');
	pattern = open(path,"r").read();
	
	# Wczytywanie listy slow.
	files = os.listdir(dir);
	files.remove('-1');
	files.sort(cmp=lambda a,b: int(a)-int(b));
	enum  = enumerate(files);
	
	# Tworzenie czystego slownika.
	dict = [];
	
	# Dodawanie slow do slownika.
	for key,name in enum:
		# Wczytywanie slowa.
		path = os.path.join(dir,name);
		word = open(path,"r").read();
		tag  = pattern % int(name);
		key  = int(name);
		
		# Dbanie o odpowiednie kodowanie.
		word = word.encode('ascii');
		tag  = tag.encode('ascii');
		
		# Dodawanie slowa do slownika.
		dict.append({
			'path': path,
			'word': word,
			'tag':  tag,
			'key':  key,
		});
	
	# Zwracanie slownika.
	return dict;

