#!/usr/bin/env python
# -*- coding: utf-8 -*-

import collections
import sys

file1 = sys.argv[1]
file2 = sys.argv[2]
f1_dict = collections.defaultdict(int)
f2_dict = collections.defaultdict(int)
n = 0

with open(file1) as my_file:
    for line in my_file:
        token1, token2, freq = line.split()
        f1_dict[token1] += int(freq)
        f2_dict[token2] += int(freq)
        n += int(freq)
        
with open(file2, 'w') as outfile:
    with open(file1) as infile:
        for line in infile:
            token1, token2, f = line.split()
            f1 = f1_dict[token1]
            f2 = f2_dict[token2]
            o11 = int(f)
            o12 = f1 - int(f)
            o21 = f2 - int(f)
            o22 = n - f1 - f2 + int(f)
            r1 = o11 + o12
            r2 = o21 + o22
            c1 = o11 + o21
            c2 = o12 + o22
            
            nominator = float(n * (o11 * o22 - o12 * o21)**2)
            denominator = float(r1 * r2 * c1 * c2)
            chisq = nominator / denominator
            
            outfile.write(token1 + ' ' + token2 + ' ' + str(o11) + ' ' + str(chisq) + '\n')
            
            
