#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

msgId="5555"

function get_brightness {
  #light -G | cut -d '.' -f 1
  bright=$(light -G | cut -d '.' -f 1)
  (( bright = (bright+2)/5, bright *= 5))
  echo "$bright"
}

function send_notification {
  #icon="preferences-system-brightness-lock"
  icon="notification-display-brightness-medium"
  brightness=$(get_brightness)
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  bar=$(seq -s "─" 0 $((brightness / 5)) | sed 's/[0-9]//g')
  # Send the notification
  #dunstify -i "$icon" -r "$msgId" -u normal "    $bar $brightness"
  dunstify  -a "brightnessControl" -i "$icon" -r "$msgId" -u normal "backlight: ${brightness}%" "$(getProgressString 20 "#" "-" $brightness)"
}

case $1 in
  up)
    # increase the backlight by 5%
    light -A 5
    send_notification
    ;;
  down)
    # decrease the backlight by 5%
    light -U 5
    send_notification
    ;;
esac
