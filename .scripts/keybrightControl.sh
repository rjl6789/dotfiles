#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
msgId="5555"
function get_brightness {
   keybright=$(light -s $(light -L | grep kbd) -G | cut -d '.' -f 1)
   #(( keybright=(keybright+2)/5, keybright *= 5))
   echo "$keybright"
}
function round_brightness {
   aaa=$(light -s $(light -L | grep kbd) -G | cut -d '.' -f 1)
   (( aaa=(aaa+2)/5, aaa*=5))
   echo "$aaa"
}

function send_notification {
  icon="keyboard"
  brightness=$(get_brightness)
  bright_out=$(round_brightness)
  echo "$brightness"
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  #bar=$(seq -s "─" 0 $((brightness / 5)) | sed 's/[0-9]//g')
  # Send the notification
  #dunstify -i "$icon" -r 5555 -u normal "    $bar $brightness"
  dunstify  -a "keybrightControl" -i "$icon" -r "$msgId" -u normal "keyboard: ${bright_out}%" "$(getProgressString 20 "#" "-" $brightness)"
}

case $1 in
  up)
    # increase the backlight by 5%
    light -s $(light -L | grep kbd) -A 5
    send_notification
    ;;
  down)
    # decrease the backlight by 5%
    light -s $(light -L | grep kbd) -U 5
    send_notification
    ;;
esac
