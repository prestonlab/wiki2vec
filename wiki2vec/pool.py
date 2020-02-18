"""Utilities for working with stimulus pools."""

import os
import glob
import re
import matplotlib.pyplot as plt


def read_items(items_file):
    """Read items from a text file."""

    with open(items_file, 'r') as f:
        items = [line.rstrip() for line in f]
    return items


def read_text(items, text_dir):
    """Read text for a set of items."""

    text = []
    for item in items:
        file_name = item.replace(' ', '_') + '.txt'
        wiki_file = os.path.join(text_dir, file_name)
        if not os.path.exists(wiki_file):
            raise IOError(f'No text found for {item}.')

        with open(wiki_file, 'r') as f:
            item_text = f.read()
        text.append(item_text)
    return text


def read_images(items, im_dir, sub_dirs=None):
    """Read image files for a set of items."""

    images = []
    for i, item in enumerate(items):
        # file names should have underscores instead of spaces
        file_base = item.replace(' ', '_')

        # search within a subdirectory if indicated
        if sub_dirs is not None:
            im_base = os.path.join(im_dir, sub_dirs[i], file_base)
        else:
            im_base = os.path.join(im_dir, file_base)

        # search for a matching image file for this item
        res = [f for f in glob.glob(im_base + '*')
               if re.search('\w+\.(png|jpg)', f)]
        if not res:
            raise IOError(f'No file found matching: {im_base}')
        elif len(res) > 1:
            raise IOError(f'Multiple matches for: {im_base}')
        im_file = res[0]

        # read the image
        image = plt.imread(im_file)
        images.append(image)
    return images
