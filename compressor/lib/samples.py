#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Funkcja wczytujaca probki.
def samples_read(dir, limit):
	
	# Tworzymy pustą listę próbek.
	samples = [];
	
	# Wczytujemy wszystkie dostepne pliki i wybieramy z nich probki.
	files = os.listdir(dir);
	files = random.sample(files, limit);
	enum  = enumerate(files);
	
	for key,name in enum:
		# Wczytujemy próbki z dysku.
		path = os.path.join(dir,name);
		file = open(path,"r").read();
		size = len(file);
		
		# I zapisujemy je do listy próbek.
		samples.append({
			'file': file,
			'path': path,
			'name': name,
			'size': size,
		});
	
	# Zwracamy wczytaną liste próbek.
	return samples;

