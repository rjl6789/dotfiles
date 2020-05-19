#!/bin/bash
fname_file="$1"
echo "$fname_file"
tmpfile="$(mktemp /home/rob/tmp/norm-volXXXX)"
shuf --output="$tmpfile" "$fname_file"
while IFS= read -r line #|| [ -n "${line}" ]
do
	echo "processing..."		
#	printf '	%s\n' "$ofname"
	ofname="${line}"
	echo "	${ofname}"
	dirout="$2/$(dirname "$ofname" | cut -d '/' -f "1,2,3,4" --complement)"
	filename="$(basename "$1")"
	filenoext="${filename%.*}"
	fileout="${dirout}/${filenoext}.mp3"
	echo "	dirout: ${dirout}"
	echo "	fileout: ${fileout}"
	echo "	tmpfile: ${tmpfile}"
	if [ ! -f "${fileout}" ]; then
		[ ! -d "${dirout}" ] && mkdir -p "$dirout"
		ffmpeg_fname="$ofname"
		ffmpeg_dir="$dirout"
		bash -c 'ffmpeg-normalize -of "$1" -ext "mp3" -c:a libmp3lame -vn -b:a 192 -f -v "$2"' _ "$ffmpeg_dir" "$ffmpeg_fname"
		echo "	finished processing"
	else
		echo "	file already processed"
	fi
done < "$tmpfile"
rm -f "$tmpfile"
