#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Include profile files
test -f /etc/profile && . /etc/profile
test -f "$HOME/.profile" && . "$HOME/.profile"
test -f /etc/xprofile && . /etc/xprofile
test -f "$HOME/.xprofile" && . "$HOME/.xprofile"

# Set key repeat rate
#xset r rate 450 35
xset r rate 300 50

# Merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Start programs in xinitrc.d
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

setxkbmap -option caps:hyper

# Start programs
numlockx &
unclutter &
exec i3
