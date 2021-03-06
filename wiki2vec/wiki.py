"""Utilities for working with Wikipedia text."""


def title_dict(headers_file):
    """Get a dictionary of text files for Wikipedia pages."""

    page_file = {}
    with open(headers_file, 'r') as f:
        for line in f:
            # path to file with this article
            doc = line.split(':')[0]

            # article title
            title = line.split('title=')[1].split('>')[0]

            page_file[title[1:-1]] = doc
    return page_file
