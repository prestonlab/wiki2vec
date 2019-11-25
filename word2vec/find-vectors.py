#!/usr/bin/env python

import argparse

from wiki2vec import word2vec


def main(items_file, vectors_file, out_file):
    # read items to look up
    with open(items_file, 'r') as f:
        items = [l.strip().replace(' ', '_') for l in f]

    # find each vector in the vectors file
    vectors = word2vec.find_vectors(items, vectors_file)

    # write out the vectors with labels
    with open(out_file, 'w') as f:
        for i, item in enumerate(items):
            f.write('{} '.format(item))
            for j in range(vectors.shape[1]):
                f.write('{:.6f}'.format(vectors[i, j]))
                if j < (vectors.shape[1] - 1):
                    f.write(' ')
            f.write('\n')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Get vectors for a list of items.")
    parser.add_argument("items", help="Path to file with one item per line.")
    parser.add_argument("vectors", help="Path to vectors file.")
    parser.add_argument("output", help="Path to item vectors output file.")
    args = parser.parse_args()

    main(args.items, args.vectors, args.output)
