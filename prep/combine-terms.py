#!/usr/bin/env python

import sys
import os

bag_dir = sys.argv[1]
output_file = sys.argv[2]

terms = set()
files = [f for f in os.listdir(bag_dir) if f.endswith('.txt')]

for bag_file in files:
    # read this count file
    with open(os.path.join(bag_dir, bag_file), 'r') as f:
        lines = f.readlines()
        for l in lines:
            # add the term to the set of all terms
            if '\t' in l:
                terms.add(l.split('\t')[1].strip())
            else:
                terms.add(l.strip())

# write a master list of terms
with open(output_file, 'w') as f:
    for term in sorted(terms):
        if '=' in term:
            # cannot support terms with an equal sign in them, as it
            # is used in the item map spec
            continue
        f.write(term + '\n')
