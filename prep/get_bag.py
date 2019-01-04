#!/usr/bin/env python

#get_bag.py   Creates bags of words for stimuli. 
#
#  Creates a bag of words for each item and saves bag of 
#  words as text file with the same name as the cleaned 
#  text file from which it selects the words in a new 
#  directory called "bag_of_words". 
#
#  OUTPUTS:
#    bag_of_words:  directory containing a text file for 
#                   each stimuli.

import sys
import os
from collections import Counter

from wiki2vec import extract

wiki_path = sys.argv[1]
out_dir = sys.argv[2]

files = [f for f in os.listdir(wiki_path) if f.endswith('.txt')]

if not os.path.exists(out_dir):
    os.makedirs(out_dir)

for filepath in files:
    print('Extracting {}'.format(filepath))
    inpath = os.path.join(wiki_path, filepath)
    outpath = os.path.join(out_dir, filepath)

    tokens = extract.extract_file(inpath)
    counts = Counter(tokens).values()
    terms = Counter(tokens).keys()

    # reverse sort by word count
    counts, terms = (list(x) for x in
                     zip(*sorted(zip(counts, terms), reverse=True,
                                 key=lambda pair: pair[0])))

    # write a tab-delimited file with one term per line, with the
    # count and the term
    with open(outpath, 'w') as output_file:
        for count, term in zip(counts, terms):
            output_file.write('{:d}\t{}\n'.format(count, term))
