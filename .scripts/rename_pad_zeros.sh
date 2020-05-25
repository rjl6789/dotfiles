#!/bin/bash
for f in *."$1"; do
	number=$(echo $f | sed 's/[^0-9]*//g')
	padded=$(printf "%04d" "$number")
	new_name=$(echo $f | sed "s/${number}/${padded}/")
	echo "moving: $f to $new_name"
	mv "$f" "$new_name"
done
