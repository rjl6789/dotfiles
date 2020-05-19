#!/bin/bash
declare -i N=372
i="copy"
ls *.jpg|sort -R |tail -$N |while read file; do
    name=$(basename "$file")
    # Something involving $file, or you can leave
    # off the while to just get the filenames
    cp $file "./${name%.*}_${i}.${name##*.}"
done
