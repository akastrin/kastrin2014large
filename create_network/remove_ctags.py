#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

file1 = sys.argv[1]
file2 = sys.argv[2]
my_array = []

with open(file1) as infile:
    for line in infile:
        line = line.rstrip()
        name,uid = line.split("|")
        my_array.append(uid)
check_tags = set(my_array)


with open(file2) as infile:
    for line in infile:
        line = line.rstrip()
        uid1,uid2,freq = line.split(" ")
        if uid1 in check_tags:
            continue
        if uid2 in check_tags:
            continue
        print uid1 + " " + uid2 + " " + freq
