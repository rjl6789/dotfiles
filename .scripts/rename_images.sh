#!/bin/bash
dir=$(pwd)
while IFS='' read -r -d ' ' mtime && IFS='' read -r -d '' filename; do
     taken=$(exiftool -s3 -DateTimeOriginal -d %Y%m%d%H%M.%S "$filename")
     if [ -z "$taken" ]; then
         taken=$(exiftool -s3 -CreateDate -d %Y%m%d%H%M.%S "$filename")
         if [ -z "$taken" ]; then
             echo ""$filename": no exif data on date taken"
         else
             touch -a -m -t "$taken" "$filename"
         fi
     else
         touch -a -m -t "$taken" "$filename"
     fi
done < <(find "$dir" -type f -printf '%T@ %p\0' | sort -zn) # -r = reverse if needed.

   let ncount=0
#   FILES=./*
#   for f in $FILES
while IFS='' read -r -d ' ' mtime && IFS='' read -r -d '' f; do
#   do
     printf 'Processing file %q with timestamp of %s\n' "$f" "$mtime" | tee -a $log_file
     ok=1
#     echo "Processing $f file..." | tee -a $log_file
     # take action on each file. $f store current file name
     filename=$(basename -- "$f")
     dirpath=$(dirname "${f}")
     echo "filename: $filename" | tee -a $log_file
     extension="${filename##*.}"
     echo "extension: $extension" | tee -a $log_file
     filename="${filename%.*}"
   
#     # get the number from the original file
#     number=${filename//[^0-9]/}
#     if [ -z "$number" ]; then
#        echo "no sequence numbers in filename - will not rename" | tee -a $log_file
#        ok=0
#     else
#        echo "number: $number" | tee -a $log_file
#     fi
     
     let ncount++
     number=$ncount
     echo "number: $number" | tee -a $log_file

     # get the date and time taken of the image
     taken=$(exiftool -s3 -DateTimeOriginal -d %Y%m%d_%H%M "$f")
     if [ -z "$taken" ]; then
         taken=$(exiftool -s3 -CreateDate -d %Y%m%d_%H%M "$f")
         if [ -z "$taken" ]; then
             echo "no exif data on date taken - not a valid camera file" | tee -a $log_file
             ok=0 
         else
             echo "taken: $taken" | tee -a $log_file
         fi
     fi
   
     # get the camera model and make any adjustments i.e.
     #   - removing spaces
     #   - removing "FinePix" from the name
     model=$(exiftool -s3 -Model "$f")
     if [ -z "$model" ]; then
        model="camera"
        echo "model: $model unknown" | tee -a $log_file
     else
        model=${model// /_}
        model=${model//"FinePix_"/}
        echo "model: $model" | tee -a $log_file
     fi
     
     if [[ $ok -eq 1 ]]; then 
        # generate the output filename
        out_name="$taken"_"$number"_"$model"."$extension"
	out_name_pp3="$taken"_"$number"_"$model".pp3
        #echo "output filename: $out_name" | tee -a $log_file
   
        # finally rename the file
        out_name=""$dirpath"/"$out_name""
        out_name_pp3=""$dirpath"/"$out_name_pp3""
        echo "output filename: $out_name" | tee -a $log_file
        if [ "$f" != "$out_name" ]; then
           mv "$f" "$out_name"
	   # rename any sidecar files
	   if [ -f "$filename".pp3 ]; then
	      mv "$filename".pp3 $out_name_pp3
	   fi
           echo "----------------------" | tee -a $log_file
           echo " " | tee -a $log_file
           echo "----------------------" | tee -a $log_file
        else
           echo "----------------------"
           echo "filenames are the same - not renaming"
           echo "----------------------"
           echo ""
        fi
     else
	echo "file not renamed:" | tee -a $log_file
	echo "   $f" | tee -a $log_file
        echo "----------------------" | tee -a $log_file
        echo " " | tee -a $log_file
        echo "----------------------" | tee -a $log_file
     fi
#   done
done < <(find "$dir" -type f -printf '%T@ %p\0' | sort -znr)
   


        echo "----------------------" | tee -a $log_file
        echo " FINISHED" | tee -a $log_file
        echo "----------------------" | tee -a $log_file
   # original way of renaming images
   #
   # capital Y = full year e.g. 2018 - lowercase y = second gigits e.g.18
   #	exiftool '-filename<${DateTimeOriginal}_${MyModel}.%le' -d %Y%m%d_%H%M%%+.2nc -r $chosen_folder
   
   
   # original way of removing spaces and replacing with underscores
   #find $PWD -type f -name "* *.jpg" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
   #find $PWD -type f -name "* *.raf" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
   #find $PWD -type f -name "* *.RAF" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
