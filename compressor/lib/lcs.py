#!/usr/bin/env python
# -*- coding: utf-8 -*-

# https://pypi.python.org/pypi/suffix-trees
from suffix_trees import STree

# Funkcja to znajdywania najwiekszego podciagu.
def lcs(strings):
	return STree.STree(strings).lcs();

