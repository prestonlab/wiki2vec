#!/usr/bin/env python

# cleanup.py   Removes uninterpretable characters.
#
#  Finds all files in given path and removes uninterpretable characters. 

import os
import sys

input_dir = sys.argv[1]
output_dir = sys.argv[2]

files = [f for f in os.listdir(input_dir) if f.endswith('.txt')]

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

for filename in files:
    in_path = os.path.join(input_dir, filename)
    out_path = os.path.join(output_dir, filename)
    with open(in_path, 'r', encoding='utf-8', errors='ignore') as infile, \
            open(out_path, 'w', encoding='ascii', errors='ignore') as outfile:
        for line in infile:
            print(*line.split(), file=outfile)
