#!/bin/bash

pdir="portrait"
ldir="landscape"
sdir="square"

mkdir -p "./$pdir"
mkdir -p "./$ldir"
mkdir -p "./$sdir"

p=1.23
l=0.82

ptot=0
pn=0

ltot=0
ln=0

stot=0
sn=0

for f in ./*.jpg
do
  r=$(identify -format '%[fx:(h/w)]' "$f")
  cp=$(echo "$r > $p" | bc -l)
  cl=$(echo "$r < $l" | bc -l)
  
  if [[ $cp -eq 1 ]] 
  then
      mv "$f" "./$pdir"
      ptot=$(echo "$r + $ptot" | bc -l)
      pn=$(echo "$pn + 1" | bc -l)
  elif [[ $cl -eq 1 ]]
  then
      mv "$f" "./$ldir"
      ltot=$(echo "$r + $ltot" | bc -l)
      ln=$(echo "$ln + 1" | bc -l)
  else
      mv "$f" "./$sdir"
      stot=$(echo "$r + $stot" | bc -l)
      sn=$(echo "$sn + 1" | bc -l)
  fi
done

pav=$(echo "$ptot / $pn" | bc -l)
lav=$(echo "$ltot / $ln" | bc -l)
sav=$(echo "$stot / $sn" | bc -l)

echo "portrait average ratio: $pav"
echo "landscape average ratio: $lav"
echo "square average ratio: $sav"
