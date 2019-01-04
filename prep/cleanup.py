#!/usr/bin/env python

#cleanup.py   Removes uninterpretable characters.
#
#  Finds all files in given path and removes uninterpretable characters. 

import os
import sys

inputdir=sys.argv[1]
outputdir=sys.argv[2]

files = [f for f in os.listdir(inputdir) if f.endswith('.txt')]

if not os.path.exists(outputdir):
    os.makedirs(outputdir)

for filename in files:
    inpath = os.path.join(inputdir, filename)
    outpath = os.path.join(outputdir, filename)
    with open(inpath,'r',encoding='utf-8',errors='ignore') as infile, \
         open(outpath,'w',encoding='ascii',errors='ignore') as outfile:
        for line in infile:
            print(*line.split(), file=outfile)
