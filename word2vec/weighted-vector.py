#!/usr/bin/env python

import sys
import os

count_file = sys.argv[1]
vector_file = sys.argv[2]

counts = []
terms = []
with open(count_file, 'w') as f:
    lines = f.readlines()
    for l in lines:
        count, term = l.split('\t')
        counts.append(count)
        terms.append(term)
