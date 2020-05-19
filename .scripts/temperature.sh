#!/bin/bash
flist=$(ls /sys/class/thermal/thermal_zone*/type)
for file in /sys/class/thermal/thermal_zone*/type
do
	ttype=$(cat "$file")
	echo "thermal zone: $file | type: $ttype"
	if [ $ttype == "x86_pkg_temp" ]; then
		tzone=$(dirname $file)
		break
	fi
done

echo "Thermal zone: $tzone"
while :; do
	temp=$(cat "$tzone/temp")
	echo "Temperature: $((temp/1000))"
	sleep 2
done

exit
