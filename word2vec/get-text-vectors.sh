#!/bin/bash

if [ $# -lt 4 ]; then
    cat <<EOF
Usage: get-text-vectors.sh items_file bag_dir vector_file out_dir

Inputs:
items_file
    Path to a text file with each of the items to generate a vector
    for. Each item should have a corresponding file in bag_dir,
    listing the count of each term in the article for that item.

bag_dir
    Path to the output directory from prep-text.sh, containing one
    tab-delimited text file for each item to generate a vector
    for. Each line should give a count of a term, then a tab, then the
    term. Terms may include spaces, in the case of named entities and
    phrases.

vector_file
    Path to a vector file. Each line must contain one vector, which may
    have any number of columns (i.e., dimensions). Columns must be
    separated by a single space character. The first column must contain
    the term corresponding to that vector. This term is assumed to have
    any spaces replaced by underscores.

out_dir
    Path to a directory to save item vectors and related files.

EOF
    exit 1
fi

items_file="$1"
bag_dir="$2"
vector_file="$3"
output_dir="$4"

if [ ! -f "$items_file" ]; then
    echo "Error: items file does not exist: $items_file"
    exit 1
fi
if [ ! -d "$bag_dir" ]; then
    echo "Error: bag-of-words directory does not exist: $bag_dir"
    exit 1
fi
if [ ! -f "$vector_file" ]; then
    echo "Error: vectors file does not exist: $vector_file"
    exit 1
fi

mkdir -p "$output_dir"

# get a full list of all terms to search for in the vector file
echo "Creating a master list of terms..."
combine-terms.py "$bag_dir" "$output_dir"/terms_orig.txt

# create a version with spaces replaced by underscores, to match the
# vectors file
tr ' ' '_' < "$output_dir"/terms_orig.txt > "$output_dir"/terms_vecname.txt

# get the subset of vectors that appear in the master list of terms
echo "Finding vectors..."
find-vectors.py "$output_dir"/terms_vecname.txt "$vector_file" "$output_dir"/terms_vec.txt

# create a vector for each item based on its terms and their frequency
echo "Creating weighted item vectors..."
article-vectors.py "$items_file" "$bag_dir" "$output_dir"/terms_vec.txt "$output_dir"/items_vec.txt
