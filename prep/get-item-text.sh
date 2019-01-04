#!/bin/bash

if [ $# -lt 2 ]; then
    echo "get-item-text.sh   Extract item pages from Wikipedia dump."
    echo
    echo "Usage: get-item-text.sh lookup_file output_dir map_file"
    echo
    echo "lookup_file"
    echo "    created by get-lookup-file.sh."
    echo
    echo "output_dir"
    echo "    directory to save wikipedia text for each item."
    echo
    echo "map_file"
    echo "    file with one line per item in stimulus pool."
    echo "    Each line should have the original name on the left,"
    echo "    then an equal sign, then the name of the Wikipedia"
    echo "    page on the right."
    echo
    exit 1
fi

lookup_file="$1"
output_dir="$2"
map_file="$3"

if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
fi

while read item; do
    # name and file for this item
    name=$(echo "$item" | cut -d = -f 1)
    file=$(echo "$item" | cut -d = -f 2)

    # get text for this item
    start="title=\"$name\">"
    finish="</doc>"
    if text=$(sed -n "\_${start}_,\_${finish}_p" "$file" | sed 1d | sed '$d'); then
	# original name(s) (the same page may be used for multiple
	# items)
	orig_names=$(grep "=${name}$" "$map_file" | cut -d = -f 1)
	while read orig; do
    	    filename=$(echo $orig | sed 's/ /_/g')
    	    echo "$name -> $orig"
    	    echo $text > "$output_dir/${filename}.txt"
	done <<< "$orig_names"
    else
    	echo "Warning: page not found for $name in $file."
    fi
done < "$lookup_file"
