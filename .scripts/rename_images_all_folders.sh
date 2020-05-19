#!/bin/bash
for d in ./*/
do
    echo "Going into directory: "$d""
    cd "$d"
    echo "....now in "$(pwd)""
    rename_images
    cd -
    
done
