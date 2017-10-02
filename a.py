
# https://pypi.python.org/pypi/suffix-trees
from suffix_trees import STree
import os
import random

sample = 2;
path   = 'raw/all';
files  = random.sample(os.listdir(path), sample);
data   = [];

for file in files:
	file = open(path+'/'+file, "r").read();
	file = file.decode('utf8').encode('ascii', 'ignore');
	data.append(file);

tree = STree.STree(data)
print(tree.lcs());

