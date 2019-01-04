#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage:   prep-vectors.sh binfile vecfile"
    echo "Example: prep-vectors.sh GoogleNews-vectors-negative300.bin vectors.txt"
    echo
    exit 1
fi

binfile="$1"
vecfile="$2"

lc="$LC_ALL"
export LC_ALL=C

# unpack binary vectors and remove non-printing characters that are
# not space, tab, or newline
unpack "$binfile" | tr -cd '\11\12\40-\176' > "$vecfile"

LC_ALL="$lc"
