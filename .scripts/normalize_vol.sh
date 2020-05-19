#!/bin/bash
dirout="$2/$(dirname "$1" | cut -d '/' -f "1,2,3,4" --complement)"
filename="$(basename "$1")"
filenoext="${filename%.*}"
if [ ! -f "${dirout}/${filenoext}.mp3" ]; then 
	mkdir -p "$dirout"
	ffmpeg-normalize -of "$dirout" -ext "mp3" -c:a libmp3lame -vn -b:a 192 -f -v "$1"
	#echo "$(dirname "$1" | cut -d '/' -f "1,2,3,4" --complement)"
	#echo "$dirout"
fi
