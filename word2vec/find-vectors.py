#!/usr/bin/env python

import sys

from wiki2vec import word2vec

items_file = sys.argv[1]
vectors_file = sys.argv[2]
out_file = sys.argv[3]

# read items to look up
with open(items_file, 'r') as f:
    items = [l.strip() for l in f]

vectors = word2vec.find_vectors(items, vectors_file)

# write out the vectors with labels
with open(out_file, 'w') as f:
    for i, item in enumerate(items):
        f.write('{} '.format(item))
        for j in range(vectors.shape[1]):
            f.write('{:.6f} '.format(vectors[i, j]))
        f.write('\n')
