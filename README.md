# Rob's Dots

## Min Dependancies

- i3lock-fancy-rapid	- AUR (screen locking - replace with any locker, adjust the call in `.xsession-spectrwm`
- xss-lock		- Arch (screen locking)
- dswitcher		- https://github.com/rjl6789/dswitcher (spectrwm switch / grab any window)
- dmenu			- Arch (for lots - note arch version seems to support xft fonts)
- alacritty		- Arch (a terminal - alter spectrwm.conf if want to use another)
- dex			- Arch (for autostarting)
- stalonetray 		- Arch - so I can see bluetooth and network - although nmtui and bluetoothctl are good cli apps
- light 		- Arch - controls screen brightness (also includes udev rules so permissions aren't an issue)
- various scripts in `.scripts` folder

## starting
- startx should work from tty
- otherwise create a desktop seesion entry for `/usr/share/xsessions` - call it something different to spectrwm.desktop as this
gets overidden when package updates - and call the `startspectrwm` script as the exec.
Note: need to copy this to /usr/local/bin (sym links don't work for unknown reason)

## Printing
- cups			- Arch - for printing
- cups-pk-helper	- Arch - for printing
- system-config-printer	- Arch - for printing
- avahi			- Arch - for printing
- nss-mdns		- Arch - for printing
- cnijfilter-ip8700	- https://github.com/rjl6789/cnijfilter-ip8700 (my printer driver)

## more dependancies and notes
- a polkit agent - e.g. mate-authentication-agent, kde etc
- libinput-gestures
- networkmanager and networkmanager applet
- blueman - for bluetooth
- pulseaudio - for making life easier with sound

lots of these have autostart's - I've created a directory and put sym links to the important ones i.e. these then get started with dex
```
at-spi-dbus-bus.desktop -> /etc/xdg/autostart/at-spi-dbus-bus.desktop
autorandr.desktop -> /etc/xdg/autostart/autorandr.desktop
blueman.desktop -> /home/rob/.config/autostart/blueman.desktop
libinput-gestures.desktop -> /home/rob/.config/autostart/libinput-gestures.desktop
nm-applet.desktop -> /etc/xdg/autostart/nm-applet.desktop
polkit-kde-authentication-agent-1.desktop -> /etc/xdg/autostart/polkit-kde-authentication-agent-1.desktop
print-applet.desktop -> /etc/xdg/autostart/print-applet.desktop
pulseaudio.desktop -> /etc/xdg/autostart/pulseaudio.desktop
```
