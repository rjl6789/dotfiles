#!/bin/bash
fake-keypress() {
	while true
	do
		xdotool key VoidSymbol
		sleep 100
	done
}

if [[ $1 =~ ^0$ ]]; then
  xset s on +dpms
  echo "No longer preventing screen sleep"
  tokill1=$(cat /tmp/abcdefg)
  tokill2=$(cat /tmp/gfedcba)
  kill -9 "$tokill1"
  kill -9 "$tokill2"
  exit 0
elif ! [[ $1 =~ ^[0-9]+$ ]]; then
  echo "example: $(basename $0) 60 ==> prevent sleeping for 60 minutes"
  echo "example: $(basename $0) 0  ==> revert to default settings"
  exit 1
fi
xset s off -dpms
echo "Preventing screen sleep for $1 minutes"
(sleep ${1}m && xset s on +dpms) &
echo $! > /tmp/abcdefg
fake-keypress &
echo $! > /tmp/gfedcba
