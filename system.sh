#!/bin/sh -e

ROOT=$(cd "$(dirname "$0")"; pwd -P)

. $ROOT/env
. $ROOT/lib.sh

##
## Base
##

pkg '
	pacman-contrib
	sudo
'

##
## CLI
##

pkg '
	git
	openssh
	vim
	bash-completion
	ncdu
'

##
## Debug
##

pkg '
	ps_mem
'

##
## Dev
##

pkg '
	make
	go
'

##
## Sec
##

pkg '
	 yubikey-manager
'

for a in enable start; do
	systemctl $a pcscd.socket
done

##
## Desktop
##

pkg '
	sway
	swaylock
	xorg-server-xwayland
	i3status
	alacritty
	firefox
'

##
## Media
##

pkg '
	pulseaudio
	pulsemixer
	mpv
	libva-intel-driver
'

# Autologin to TTY 1:
tmpl /etc/systemd/system/getty@tty1.service.d/override.conf '$AUTOLOGIN_USER'

# Passwordless sudo for wheel:
echo '%wheel ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
