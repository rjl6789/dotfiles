#!/bin/bash
find /tmp/p090/ -name "IMG*.JPG" | while IFS= read -r file; do
  convert "$file" -rotate 90 "$file"_rotated.JPG
done
