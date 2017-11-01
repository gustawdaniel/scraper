#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Funkcja wczytujaca probki.
def samples_read(dir, limit):
	samples = [];
	
	files = os.listdir(dir);
	files = random.sample(files, limit);
	enum  = enumerate(files);
	
	for key,name in enum:
		path = os.path.join(dir,name);
		file = open(path,"r").read();
		size = len(file);
		
		samples.append({
			'file': file,
			'path': path,
			'name': name,
			'size': size,
		});
	
	return samples;

