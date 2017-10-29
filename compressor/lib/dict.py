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
	path = os.path.join(dir,'0');
	file = open(path,"w");
	file.write(pattern);
	file.close();
	
	# Zwracanie czystego slownika.
	return [];

# Dodawanie slowa do slownika.
def dict_add(dir,dict,word):
	
	# Wczytywanie wzorca tagu.
	path    = os.path.join(dir,'0');
	pattern = open(path,"r").read();
	
	# Zapisywanie nowego slowa.
	name = str(len(os.listdir(dir)));
	path = os.path.join(dir,name);
	file = open(path,"w"); 
	file.write(word);
	file.close();
	
	# Tworzenie nowego tagu.
	tag = pattern % name;
	
	# Dodawanie nowego slowa do slownika.
	dict.append({
		'path': path,
		'word': word,
		'name': name,
		'tag':  tag,
	});
	
	# Zwracanie rozszerzonego slownika.
	return dict;

# Wczytywanie slownika.
def dict_load(dir):
	
	# Wczytywanie wzorca tagu.
	path    = os.path.join(dir,'0');
	pattern = open(path,"r").read();
	
	# Wczytywanie listy slow.
	files = os.listdir(dir);
	files.remove('0');
	files.sort(cmp=lambda a,b: int(a)-int(b));
	enum  = enumerate(files);
	
	# Tworzenie czystego slownika.
	dict = [];
	
	# Dodawanie slow do slownika.
	for key,name in enum:
		path = os.path.join(dir,name);
		file = open(path,"r").read().decode('utf8').encode('ascii', 'ignore');
		tag  = pattern % int(name);
		
		dict.append({
			'path': path,
			'word': file,
			'name': name,
			'tag':  tag,
		});
	
	# Zwracanie slownika.
	return dict;

