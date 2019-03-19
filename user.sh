#!/bin/sh -e

ROOT=$(cd "$(dirname "$0")"; pwd -P)
DOTFILES=$ROOT/dotfiles

. $ROOT/lib.sh

##
## Dotfiles
##

find $DOTFILES -type f -print0 | while IFS= read -r -d '' f; do
	rel=${f##$DOTFILES/}
	src="$DOTFILES/$rel"
	dst="$HOME/$rel"

	mkdir -p "$(dirname "$dst")"

	if ! [ -L "$dst" ]; then
		ln -sf "$src" "$dst"
	fi
done

##
## SSH Agent
##

svc ssh-agent --user

##
## Firefox
##

ff_profile_dir=~/.mozilla/firefox

for d in $ff_profile_dir/*.default $ff_profile_dir/*.priv; do
	[ -d "$d" ] || continue

	tmpl "$d"/chrome/userChrome.css \
		/home/user/.mozilla/firefox/profile/chrome/userChrome.css
done

##
## Vim
##

f=~/.vim/autoload/plug.vim
[ -e $f ] ||
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
unset f

##
## Flatpak
##

flat pms \
	tv.plex.PlexMediaPlayer \
	https://knapsu.eu/data/plex/tv.plex.PlexMediaPlayer.flatpakref
flat spotify com.spotify.Client
