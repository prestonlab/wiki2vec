#!/usr/bin/env python

import sys

map_path = sys.argv[1]

with open(map_path, 'r') as map_file:
    for line in map_file:
        for term in line.rstrip('\n').split('='):
            if term.startswith(' '):
                print('Warning: {} starts with a space.'.format(term))
            if term.endswith(' '):
                print('Warning: {} ends with a space.'.format(term))
