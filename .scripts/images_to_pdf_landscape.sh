#!/bin/bash

tdir="$(mktemp -d /tmp/image2pdfXXXXXX)"
dpi="300"
ls *.jpg | xargs -I@ convert @ -compress jpeg -quality 70 -density "$dpi"x"$dpi" -units PixelsPerInch -resize $(("$dpi"*1169/100))x$(("$dpi"*827/100)) "$tdir"/@.pdf

pdftk "$tdir"/*.pdf cat output merged.pdf

rm -rf "$tdir" 2>/dev/null



