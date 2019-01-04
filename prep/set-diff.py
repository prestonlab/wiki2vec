#!/usr/bin/env python

import sys

file1 = sys.argv[1]
file2 = sys.argv[2]

with open(file1, 'r') as f:
    lines1 = f.readlines()
with open(file2, 'r') as f:
    lines2 = f.readlines()

set1 = set(lines1)
set2 = set(lines2)

for line in sorted(set1):
    if line not in set2:
        print(line.strip())
