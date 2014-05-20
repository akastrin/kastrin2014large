#!/bin/bash

# Build co-occurence table using join command
# Output file: uid2uid_all.coc
./create_coc_table_all.sh

# Convert directed to undirected co-occurence graph, remove self-loops
# Input file: uid2uid_all.coc
# Output file: uid2uid_all.txt
python directed2undirected.py uid2uid_all.coc > uid2uid_all.txt

# Remove relations with check tags
# Input file: check_tags.txt, uid2uid_all.txt
# Output file: uid2uid_all_ct.txt
python remove_ctags.py check_tags.txt uid2uid_all.txt > uid2uid_all_ct.txt

# Compute association measure
# Input file: uid2uid_all_ct.txt
# Output file: uid2uid_all_chi2.txt
python compute_chisq.py uid2uid_all_ct.txt uid2uid_all_chi2.txt

# Python dictionary can't be sort, so use classical sort to sort concepts
sort  -k1 -k2 uid2uid_all_chi2.txt > uid2uid_all_chi2.srt

# Final relation file
awk 'BEGIN {FS = " "; OFS = " "}; {if ($4 > 3.841) print $1, $2}' uid2uid_all_chi2.srt > network_all.txt
