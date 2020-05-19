#!/bin/sh
. ~/.xprofile
. ~/.profile
xrdb -merge ~/.Xresources
exec startspectrwm
