#!/usr/bin/env python

import os
import sys

from wikisim import word2vec

items_file = sys.argv[1]
text_dir = sys.argv[2]
vectors_file = sys.argv[3]
out_file = sys.argv[4]

# read items, with spaces replaced with underscores
with open(items_file, 'r') as f:
    items = [l.strip().replace(' ', '_') for l in f]

print("Building index of vectors...")
vf = word2vec.VectorFile(vectors_file)

with open(out_file, 'w') as outf:
    for item in items:
        count_file = os.path.join(text_dir, item + '.txt')
        if not os.path.exists(count_file):
            raise IOError('Article file does not exist: {}'.format(count_file))

        # read items, and term counts to use as weights
        with open(count_file, 'r') as f:
            weights = []
            terms = []
            for line in f:
                count, term = line.split('\t')
                weights.append(int(count))
                terms.append(term.strip())
        
        # calculate the vector for this article
        vector = vf.weighted_vector(terms, weights)

        # write the weighted vector to the output file
        outf.write('{} '.format(item))
        for j in range(len(vector)):
            outf.write('{:.6f} '.format(vector[j]))
        outf.write('\n')
