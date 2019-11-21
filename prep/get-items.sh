#!/bin/bash

if [ $# -lt 2 ]; then
    echo "get-items.sh   Get names of all experimental stimuli."
    echo
    echo "Usage: get-items.sh stim_dir output_file"
    echo
    exit 1
fi

stim_dir="$1"
output_file="$2"

if [ -f "$output_file" ] ; then
    rm "$output_file"
fi

for t in female male manmade natural; do
    items=$(find "$stim_dir/$t" -type f -name "*.jpg" | tr '\n' ' ')
    for i in $items; do
	      echo $(basename "$i" .jpg) | sed 's/_/ /g' >> "$output_file"
    done
done
