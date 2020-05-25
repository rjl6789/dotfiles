#!/bin/bash

# quick conf file picker
# requires a list of keys, locations and commands to run in ~/.local/share/conflist#


# has fzf as a dependancy
command -v fzf >/dev/null 2>&1 || { echo >&2 "I require fzf but it's not installed.  Aborting."; exit 1; }

confloc="$HOME/.local/share/conflist"

# put friendly names into a variable
keys=$(awk '/^[^#]/ {print $1}' $confloc)

# create associative arrays

eval declare -A map_location=(
    $(awk '/^[^#]/ { printf "[\"%s\"]=\"%s\"\n", $1, $2}' "$confloc")
)

eval declare -A map_command=(
	$( sed -e '/^\s*#.*$/d' -e '/^\s*$/d' "$confloc" | awk '/^[^#]/ { key=$1; $1=$2=""; command=$0} {gsub(/^[ \t]+/, "", command); printf "[\"%s\"]=\"%s\"\n", key, command}' )
)

# command for getting all files in a list and directory contents
#file=$(cat "$confloc" | xargs echo | xargs -I@ sh -c 'rg -l --no-messages --files @' | fzf --preview='head -50 {}')

key=$( echo "$keys" | fzf )
location=${map_location["$key"]}
exe=${map_command["$key"]}

if [ ! -z $key ]; then
	case $exe in
		edit)
			$EDITOR "$location"
			;;
		sedit)
			sudo $EDITOR "$location"
			;;
		dsearch)
			$HOME/.scripts/vimdir.sh "$location"
			;;
		*)
			echo "not a valid command"
			echo; read -rsn1 -p "Press any key to continue . . ."; echo
			;;
	esac
	#echo "$exe $location" | xargs -I@ sh -c '@'
	#echo "running '${exe} ${location}'..."
	#sh -c '$1 $2' sh "$exe" "$location"
	
	# run a command from an array
	#run=("$exe" "$location")
	#${run[@]}
else
	echo "nothing slected"
fi


