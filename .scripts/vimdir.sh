#!/bin/bash
# file picker then edit
dir="$1"

file=$( rg --files "$dir" | fzf)
#file=$( find "$dir" -type f | fzf)
if [ ! -z $file ]; then
	#echo "$file" | xargs -I@ alacritty -e nvim @
	echo "$file" | xargs -I@ nvim @
else
	echo "nothing slected"
fi


