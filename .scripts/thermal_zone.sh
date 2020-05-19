#!/usr/bin/env bash

# determine thermal zone for temperature
tinfo="$(ls -1 /sys/class/thermal/ | grep thermal_zone)"
for tzone in $tinfo; do
    ttype="$(cat /sys/class/thermal/"$tzone"/type)"
    if [ "$ttype" = "x86_pkg_temp" ]; then
	    THERMAL_ZONE="$(echo $tzone | grep -o '.$')"
	    echo "Thermal zone is $THERMAL_ZONE - $ttype - $tzone"
	    echo "                /sys/class/thermal/"$tzone"/type"
    fi 
done

if [[ $THERMAL_ZONE ]]; then
    export THERMAL_ZONE
fi

