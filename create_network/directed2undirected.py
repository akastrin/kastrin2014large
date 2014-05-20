#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

file1 = sys.argv[1]
coc_dict = {}
with open(file1) as infile:
    for line in infile:
        concept_1, concept_2, freq = line.split()
        if concept_1 == concept_2:
            continue
        coc_tuple = (concept_1, concept_2)
        if coc_tuple[::-1] in coc_dict:
            continue
        coc_dict[coc_tuple] = freq

for key, value in coc_dict.items():
    print key[0], key[1], value
