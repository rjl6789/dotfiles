#!/bin/bash
# baraction.sh for spectrwm status bar

## DISK
hdd() {
	hdd1_cap="$(( $(df | awk 'NR==4{print $2}' | sed 's/[^0-9]*//g') / 1048576 ))"
	hdd1_use="$(( $(df | awk 'NR==4{print $3}' | sed 's/[^0-9]*//g') / 1048576 ))"
	hdd2_cap="$(( $(df | awk 'NR==9{print $2}' | sed 's/[^0-9]*//g') / 1048576 ))"
	hdd2_use="$(( $(df | awk 'NR==9{print $3}' | sed 's/[^0-9]*//g') / 1048576 ))"
	#hdd_root="$(df -h | awk 'NR==4{print $3}')"
	#hdd_home="$(df -h | awk 'NR==9{print $4}')"
	echo -e "HDD: r-${hdd1_use}/${hdd1_cap}G h-${hdd2_use}/${hdd2_cap}G"
	hdd1p=$(( 100 * hdd1_use / hdd1_cap))
	hdd2p=$(( 100 * hdd2_use / hdd2_cap))
	#if command -v spark &>/dev/null; then
	#	sparks1=$(spark 0 ${hdd1p} 100)
	#	sparks2=$(spark 0 ${hdd2p} 100)
	#	GRAPH1=${sparks1:1:1}
	#	GRAPH2=${sparks2:1:1}
	#	printf "%s%s %s %s %s" "HDD: " $hdd_root $GRAPH1 $hdd_home $GRAPH2 
	#else
	#	echo -e "HDD: $hdd_home"
	#
	#fi
}

## RAM
mem() {
	mem=`free | awk '/Mem/ {if ($3 < 1048576) {printf "%dM/%dG\n", $3 / 1024.0 , $2 / 1024.0 / 1024.0} else {printf "%dG/%dG\n", $3 / 1024.0 / 1024.0, $2 / 1024.0 / 1024.0}}'`
  echo -e "RAM: $mem"
}

## temperature
tmp() {
	temp=$(cat "$tzone/temp")
	echo "$((temp/1000))C"
}
## Battery
battery_charge() {
	battery_path="$1"
	battery_state=$(cat $battery_path/status)
	battery_full=$battery_path/energy_full
	battery_current=$battery_path/energy_now
	if [ $battery_state == 'Discharging' ]; then
		BATT_CONNECTED=0
	elif [ $battery_state == 'Unknown' ]; then
		BATT_CONNECTED=2
	else
		BATT_CONNECTED=1
	fi
	now=$(cat $battery_current)
	full=$(cat $battery_full)
	BATT_PCT=$((100 * $now / $full))
}

apply_colors() {
    # Green
    if [[ $BATT_PCT -ge 65 ]]; then
            COLOR=$good_color
    # Yellow
    elif [[ $BATT_PCT -ge 25 ]] && [[ $BATT_PCT -lt 65 ]]; then
            COLOR=$middle_color
            COLOR="%F{$middle_color}"
            COLOR=$middle_color
    # Red
    elif [[ $BATT_PCT -lt 25 ]]; then
            COLOR=$warn_color
    fi
}

print_status() {
	if ((emoji)) && ((BATT_CONNECTED == 1)); then
		GRAPH="⚡-"
		#    elif ((emoji)) && ((BATT_CONNECTED == 2)); then
		#        GRAPH=""
		#        GRAPH=""
	elif (( ! no_fancy )); then
		if command -v spark &>/dev/null; then
			sparks=$(spark 0 ${BATT_PCT} 100)
			GRAPH=${sparks:1:1}
		else
			ascii=1
		fi
	else
		GRAPH="$1-"
	fi

	if ((ascii)); then
		barlength=${#ascii_bar}
		# Battery percentage rounded to the lenght of ascii_bar
		rounded_n=$(( $barlength * $BATT_PCT / 100 + 1))
		# Creates the bar
		GRAPH=$(printf "[%-${barlength}s]" "${ascii_bar:0:rounded_n}")
	fi

	printf "%s%s%s" "$COLOR" "$GRAPH" "$BATT_PCT%"
}

bat() {
	good_color="+@fg=2;"
	middle_color="+@fg=3;"
	warn_color="+@fg=1;"
	emoji=1
	ascii_bar='---'
	ascii=0
	no_fancy=1
	bat0_path="/sys/class/power_supply/BAT0"
	bat1_path="/sys/class/power_supply/BAT1"

	battery_charge $bat0_path
	bat1_pct=$BATT_PCT
	apply_colors
	bat0=$(print_status a)

	battery_charge $bat1_path
	bat2_pct=$BATT_PCT
	apply_colors
	bat1=$(print_status b)

	BATT_PCT=$(( (bat1_pct + bat2_pct)/2 ))
	apply_colors
	#bat0=$(/usr/local/bin/battery -s -b /sys/class/power_supply/BAT0)
	#bat1=$(/usr/local/bin/battery -s -b /sys/class/power_supply/BAT1)
	echo -e "${COLOR}PWR: $bat0 $bat1"
}

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "CPU: $cpu%"
}

## VOLUME
vol() {
    vol=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }' | sed 's/on://g'`
    echo -e "VOL: $vol"
}

SLEEP_SEC=3
## find temperature zone
for file in /sys/class/thermal/thermal_zone*/type
do
	ttype=$(cat "$file")
	if [ $ttype == "x86_pkg_temp" ]; then
		tzone=$(dirname $file)
		break
	fi
done
#loops forever outputting a line every SLEEP_SEC secs

# It seems that we are limited to how many characters can be displayed via
# the baraction script output. And the the markup tags count in that limit.
# So I would love to add more functions to this script but it makes the 
# echo output too long to display correctly.
while :; do
#    echo "+@fg=1;+@fn=1;💻+@fn=0;$(cpu)+@fg=0; | +@fg=2;+@fn=1;💾+@fn=0;$(mem)+@fg=0; | +@fg=3;+@fn=1;💿+@fn=0;$(hdd)+@fg=0; | +@fg=4;+@fn=1;🔈+@fn=0;$(vol)+@fg=0; |"
echo "+@fg=4;+@fn=0;$(cpu) $(tmp)+@fg=0; | $(bat)+@fg=0; | +@fg=5;$(mem)+@fg=0; | +@fg=6;$(hdd)+@fg=0; | +@fg=3;$(vol)+@fg=0; |"
 sleep $SLEEP_SEC
done

