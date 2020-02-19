"""Utilities for plotting dissimilarity matrices."""

import numpy as np
import scipy.spatial.distance as sd
from sklearn import manifold
import matplotlib.pyplot as plt
from matplotlib.offsetbox import OffsetImage, AnnotationBbox


def plot_dsm(dsm, ax=None, prange=(1, 99)):
    """Plot pairwise dissimilarity values as a matrix."""

    if ax is None:
        ax = plt.gca()

    perc = np.percentile(sd.squareform(dsm), prange)
    h = ax.pcolor(dsm, vmin=perc[0], vmax=perc[1])
    ax.set_aspect(1)
    ax.invert_yaxis()
    return h


def embed_mds(dsm):
    """Calculate a two-dimensional MDS embedding for a dissimilarity matrix."""

    embedding = manifold.MDS(n_components=2, dissimilarity='precomputed')
    X = embedding.fit_transform(dsm)
    x, y = X.T
    return x, y


def image_scatter(x, y, images, ax=None, zoom=1):
    """Make a scatter plot with images instead of points."""

    if ax is None:
        ax = plt.gca()

    artists = []
    x, y = np.atleast_1d(x, y)
    for x0, y0, im, in zip(x, y, images):
        im0 = OffsetImage(im, zoom=zoom)
        ab = AnnotationBbox(im0, (x0, y0), xycoords='data', frameon=False)
        artists.append(ax.add_artist(ab))
    ax.update_datalim(np.column_stack([x, y]))
    ax.autoscale()
    return artists


def plot_mds(dsm, images, ind=None, embedding='mds', zoom=1, ax=None):
    """Plot multidimensional scaling of a dissimilarity matrix."""

    if ind is not None:
        dsm = dsm[ind, ind]
        images = images[ind]

    if embedding == 'precomputed':
        x, y = dsm
    elif embedding == 'mds':
        x, y = embed_mds(dsm)
    else:
        raise ValueError(f'Invalid embedding type: {embedding}')

    artists = image_scatter(x, y, images, ax=ax, zoom=zoom)
    return artists
