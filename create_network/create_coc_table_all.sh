#!/bin/bash

# Input file: xml2txt.uid
# Output file: uid2uid_all.coc
# First delete last column (MeSH Major indicator)
cut -d "|" --output-delimiter=" " -f 1,2 xml2txt.uid > pmid2mesh.txt
sort -t " " -k 1 pmid2mesh.txt > pmid2mesh.srt
join -t " " -1 1 -2 1 pmid2mesh.srt pmid2mesh.srt > tmp.join
cut -d " " --output-delimiter=" " -f 2,3 tmp.join > tmp.cut
sort tmp.cut > tmp.sort
uniq -c tmp.sort > tmp.uniq
awk 'BEGIN {FS = " "; OFS = " "}; {print $2,$3,$1}' tmp.uniq > uid2uid_all.coc
rm pmid2mesh.txt pmid2mesh.srt tmp.join tmp.cut tmp.sort tmp.uniq
