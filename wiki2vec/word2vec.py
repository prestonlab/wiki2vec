"""Utilities for working with word2vec vectors."""

import warnings
import numpy as np


def read_lines(f):
    """Read lines from a file while checking for unicode problems."""
    while True:
        try:
            yield(next(f))
        except StopIteration:
            break
        except UnicodeDecodeError as e:
            warnings.warn('Unicode decoding problem.', UnicodeWarning)
            pass


def find_vectors(items, vectors_file):
    """Find terms in a vectors file.

    Parameters
    ----------
    items : list of strings
        List of terms to get vectors for.

    vectors_file : string
        Path to a vectors file. In each line of the file, the first
        column is the term, and the remaining columns give the vector.

    Returns
    -------
    vectors : [items x dimensions] ndarray
        Set of vectors loaded from the vectors file, in the same order
        as items.
    """

    item_set = set(items)
    with open(vectors_file, 'r', encoding='utf-8') as f:
        header_line = f.readline()
        n_dim = int(header_line.split()[1])
        vectors = np.empty((len(items), n_dim))
        vectors.fill(np.nan)
        for line in read_lines(f):
            # get the term for this vector
            term = line.split()[0]
            if term in item_set:
                # if the term matches anything in the item set, store the vector
                x = np.array(line.split()[1:(n_dim + 1)], dtype=float)
                vectors[items.index(term)] = x

                # remove that term so we won't waste time checking for it
                item_set.remove(term)

                if not item_set:
                    # no more items to look up
                    break
    return vectors


def article_vector(count_file, vectors_file):
    """Calculate a vector weighted by term count."""

    # read items, and term counts to use as weights
    with open(count_file, 'r') as f:
        weights = []
        items = []
        for line in f:
            count, item = line.split('\t')
            weights.append(count)
            items.append(item)

    vf = VectorFile(vectors_file)
    vector = vf.weighted_vector(items, weights)


class VectorFile:
    """Class for reading data from large files with vector data."""

    def __init__(self, vectors_file):
        # create a dict for the file
        self.filepath = vectors_file
        self.term_offset = {}
        self.n_term = 0
        offset = 0
        with open(vectors_file, 'r') as f:
            for line in f:
                term = line.split()[0]

                # if a term occurs multiple times, only save the first one
                if term not in self.term_offset.keys():
                    # save the position of this line in the file
                    self.term_offset[term] = offset

                offset += len(line)
                self.n_term += 1
            if line.find('\b'):
                ind = line.find('\b')
                line = line[:ind]
            self.n_dim = len(line.strip().split()) - 1

    def get_item(self, item):
        """Load the vector for an item."""

        # check if it's in the vectors file
        if item not in self.term_offset.keys():
            return None

        # get the line in the file
        offset = self.term_offset[item]
        with open(self.filepath, 'r') as f:
            f.seek(offset)
            vec_line = f.readline()
            vector = np.array([float(x) for x in vec_line.split()[1:]])
        return vector

    def get_item_list(self, item_list):
        """Load vectors for a list of items."""

        n_item = len(item_list)
        vectors = np.empty((n_item, self.n_dim))
        vectors.fill(np.nan)

        with open(self.filepath, 'r') as f:
            for i, item in enumerate(item_list):
                if item in self.term_offset.keys():
                    f.seek(self.term_offset[item])
                    vec_line = f.readline()

                    # remove ending backspace characters if present
                    if vec_line.find('\b'):
                        ind = vec_line.find('\b')
                        vec_line = vec_line[:ind]

                    vectors[i] = np.array([float(x) for x in
                                           vec_line.split()[1:]])
        return vectors

    def weighted_vector(self, items, weights):
        """Calculate a weighted vector from multiple items."""

        n_item = len(items)
        vector = np.zeros(self.n_dim)

        for i in range(n_item):
            item_vec = self.get_item(items[i])
            if item_vec is not None and not np.any(np.isnan(item_vec)):
                vector += item_vec * weights[i]

        return vector
