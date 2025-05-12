export TERMINAL=kitty

# otherwise slack will not be able to send notifications via dunst
# (and other app might not work properly too)
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1001/bus

export XDG_DATA_DIRS=/usr/share/gnome:/usr/local/share/:/usr/share/:/usr/share/glib-2.0/schemas

xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap

nm-applet &
# volumeicon &
pasystray &

# Manually set location for redshift, because otherwise it'll crash
# with "Trying location provider geoclue2...":
# https://github.com/jonls/redshift/issues/445
# It seems that at this moment in time (2021-06-21), none of the
# proposed fixes work in Debian to use Geoclue. So, we're hard-coding.
# As long as we don't travel too far, this works just as well.
# redshift -l 47.05:9.06 &
redshift-gtk -l 47.05:9.06 &

blueman-applet &
emacs --daemon &

# parcimonie incrementaly refreshes a GnuPG keyring
parcimonie &

# Parcellite is a lightweight GTK+ clipboard manager
# Does not work here, anymore. Moved to .i3/config.
# parcellite &
# clipit &


# Wait for a bit. Otherwise there will be a racing condition for
# several X-related commands like `xset`. Thanks @nico.
# sleep 2

# Configure touchpad
TOUCHPAD=`xinput list --name-only | grep -i Synaptics`
xinput --set-prop "$TOUCHPAD" "libinput Accel Speed" 1
xinput --set-prop "$TOUCHPAD" "libinput Tapping Enabled" 1
xinput --set-prop "$TOUCHPAD" "libinput Natural Scrolling Enabled" 1

# don't activate screensaver
xset s off &
# disable DPMS (Energy Star) features.
xset -dpms &
# don't blank the video device
xset s noblank &

# re-use ssh-agent and/or gpg-agent between logins
keychain &

# Load gnome-keyring
dbus-update-activation-environment --systemd DISPLAY
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
# eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Gnome HiDPI (e.g. firefox)
export GDK_DPI_SCALE=0.5
export GDK_SCALE=2

# Elementary (EFL)
export ELM_SCALE=1

# QT HiDPI
export QT_SCREEN_SCALE_FACTORS=1
export QT_SCALE_FACTOR=0.75
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Deprecated, but still used by some applications (OBS). However, when
# also set globally, it'll screw up the other two QT settings. For
# example keepassxc will have a huge interface, then. Hence, The
# strategy is to set the QT_DEVICE_PIXEL_RATIO in `bin` stubs.
# export QT_DEVICE_PIXEL_RATIO=2
#QT_FONT_DPI=96 vym

xset +fp /home/munen/.fonts
xset fp rehash

# The nvidia card does not handle the internal screen, it just black.
# To fix this we have "Hybrid Graphics" in the BIOS activated (instead
# of Discrete Graphics, which would deactivate the Intel card). In
# xorg config we bind the internal screen to the Intel Card and make
# the Nvidia card the primary. To use the internel screen we need to
# "proxy" the Intel Card through the Nvidia Card, at least that's how
# we understand it. Maybe it's the other way round, no clue. This does
# the proxying:
xrandr --setprovideroutputsource modesetting NVIDIA-0
# And this activates the proxied screen
xrandr --output eDP-1-1 --auto

# Better sound quality for web conferencing
~/bin/pa-load-module-echo-cancel &

export XDG_CURRENT_DESKTOP=Unity

# Cloud storage
dropbox start -i &
# Automounter for removable media
udiskie --automount --notify --tray &
# xinput --set-prop "MX Vertical Mouse" "libinput Accel Speed" 0
# kwalletd5 &

dunst &

# Bug fixes for Guix in Debian:

# Otherwise the xcursor path from Guix will be used and the cursor
# will be very small.
export XCURSOR_PATH=/usr/share/icons/:/home/munen/.guix-profile/share/icons

# Mount securefs
kitty --hold -- bash -c "securefs mount -b ~/securefs /mnt/securefs"

exec i3
