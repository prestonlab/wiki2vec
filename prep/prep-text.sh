#!/bin/bash

if [ $# -lt 3 ]; then
    echo "prep-text.sh   Get Wikipedia text for a list of items."
    echo
    echo "Usage: prep-text.sh map_file wiki_dir output_dir"
    echo
    echo "map_file"
    echo "    file with one line per item in stimulus pool."
    echo "    Each line should have the original name on the left,"
    echo "    then an equal sign, then the name of the Wikipedia"
    echo "    page on the right."
    echo
    echo "wiki_dir"
    echo "    absolute path to Wikipedia dump from Wikipedia Extractor."
    echo
    echo "output_dir"
    echo "    directory where item article text files will be saved."
    echo
    exit 1
fi

map_file="$1"
wiki_dir="$2"
output_dir="$3"

echo "Checking map file for leading and trailing spaces..."
check_item_map.py "$map_file"

mkdir -p "$output_dir"

cp "$map_file" "$output_dir"/items_map.txt
cd "$output_dir" || exit 1

# remove any existing output files
rm -f items_{orig,wiki,lookup}.txt
rm -rf itemtext{,_clean,_bag}

# get a list of all titles, for faster search for specific items
if [ ! -s all_headers.txt ]; then
    echo "Generating index of all Wikipedia pages..."
    grep -r 'title=".*"' "$wiki_dir" > all_headers.txt
fi

# search for each item and get the corresponding file in the dump
echo "Generating index of item pages..."
cut -d = -f 1 items_map.txt > items_orig.txt
cut -d = -f 2 items_map.txt > items_wiki.txt
get-item-lookup.py items_wiki.txt all_headers.txt items_lookup.txt

# extract Wikipedia text for each item
echo "Extracting text for each item..."
get-item-text.sh items_lookup.txt itemtext items_map.txt

echo "Removing non-ascii characters..."
cleanup.py itemtext itemtext_clean

echo "Creating a bag-of-words for each item..."
get_bag.py itemtext_clean itemtext_bag
