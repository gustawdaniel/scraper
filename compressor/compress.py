#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os

execfile("lib/dict.py")
execfile("lib/compress.py");
execfile("lib/samples.py");

dir_dict = sys.argv[1];
dir_in   = sys.argv[2];
dir_out  = sys.argv[3];

dict  = dict_load(dir_dict);
files = os.listdir(dir_in);

for name in files:
	path_in  = os.path.join(dir_in,  name);
	path_out = os.path.join(dir_out, name);
	buff     = open(path_in,"r").read().decode('utf8').encode('ascii','ignore');
	buff     = compress(dict,buff);
	file = open(path_out,"w");
	file.write(buff);
	file.close();

