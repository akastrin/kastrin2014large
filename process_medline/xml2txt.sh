#!/bin/bash

for file in `ls /home/andrej/Documents/dev/medline/dist/2013/xml/`
do
  echo "Processing $file"
  python3 tools/test4.py /home/andrej/Documents/dev/medline/dist/2013/xml/$file >> xml2txt.uid
done
