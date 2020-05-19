#!/bin/sh
. ~/.profile
. ~/.xprofile
xrdb -merge ~/.Xresources
exec startspectrwm
