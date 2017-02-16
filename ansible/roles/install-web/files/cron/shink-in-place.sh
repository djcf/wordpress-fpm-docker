#!/usr/bin/env bash
# Purpose: batch image resizer
# Author: daniel

# absolute path to image folder
FOLDER=/var/www

# max height
MAX_WIDTH=1600

# max width
MAX_HEIGHT=1600

MAX_SIZE=500000

for f in $(find $FOLDER -iname '*.jpg' -o -iname '*.png' -iname '*.jpeg' -type f)
do
    mogrify -resize "$MAX_WIDTHx$MAX_HEIGHT>" $f
	if [ $(stat --format %s $f) -ge $MAX_SIZE ]; then
		mogrify -quality 60 $f
	fi
done