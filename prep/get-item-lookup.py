#!/usr/bin/env python

import os
import sys

from wiki2vec import wiki

items_file = sys.argv[1]
headers_file = sys.argv[2]
lookup_file = sys.argv[3]

# generate a dictionary with the file containing each Wikipedia page
wiki = wiki.title_dict(headers_file)

# read Wikipedia titles for each item
with open(items_file, 'r') as f:
    items = [l.strip() for l in f]

# for each item, write out the file for its article
with open(lookup_file, 'w') as f:
    for item in items:
        if item not in wiki.keys():
            raise  ValueError('{} not found in Wikipedia page titles'.format(item))
        pagefile = wiki[item]
        f.write('{}={}\n'.format(item, pagefile))
