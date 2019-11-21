#!/bin/bash

if [ $# -lt 3 ]; then
    echo "get-item-lookup.sh   Find each item in Wikipedia dump."
    echo
    echo "Usage: get-item-lookup.sh items_file headers_file output_dir"
    echo
    echo "items_file"
    echo "    file with one line per item in stimulus pool. Each"
    echo "    must match a title of a Wikipedia page in the dump."
    echo
    echo "headers_file"
    echo "    created by get-all-titles.sh."
    echo
    echo "lookup_file"
    echo "    file with the location of each item in the Wikipedia dump."
    echo
    exit 1
fi

items_file="$1"
titles_file="$2"
headers_file="$3"
lookup_file="$4"

if [ -f "$lookup_file" ]; then
    rm "$lookup_file"
fi

while read -r item; do
    if entry=$(grep -n -m 1 "^$item$" "$titles_file"); then
	      lineno=$(echo "$entry" | cut -d ':' -f 1)
	      file=$(sed "${lineno}q;d" "$headers_file" | cut -d ':' -f 1)
	      echo "$item"
	      echo "$item=$file" >> "$lookup_file"
    else
	      echo "Warning: no Wikipedia page found for $item."
    fi
done < "$items_file"
