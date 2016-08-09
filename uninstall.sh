#!/usr/bin/env sh

#modules=$(find . -maxdepth 1 -type d \! -path "./.git" \! -path "\." -printf '%f\n')
#
#for module in ${modules}; do
#	stow -D ${module}
#	if [ "${module}" == "bash" ]; then
#		sudo stow -D --target=/root ${module}
#	fi
#done

git submodule init
git submodule update

# Bash (for current user and root user)
stow -D bash
sudo stow -D -t /root bash

# BitDay wallpapers
stow -D BitDay
crontab -l > cron.install
sed -i '/BitDay/d' cron.install
printf "# BitDay wallpaper rotation\n0        *       *       *       *       ${HOME}/.config/BitDay/change.sh\n@reboot                                  ${HOME}/.config/BitDay/change.sh\n" >> cron.install
sed -n '/BitDay/!p' cron.install > cron.backup
printf "\nNOTE: You may have to manually restore your crontab, a backup has been saved to cron.backup in the current directory.\n\n"

# Cava
stow -D cava

# Curl
stow -D curl

# Fonts
stow -D fonts
fc-cache -f

# Custom binary scripts
stow -D magic-bin

# MPD
stow -D mpd

# Nano syntax highlight files
stow -D nano

# Neovim and Vim
stow -D neovim

# ncmpcpp
stow -D ncmpcpp

# Redshift GTK
stow -D redshift

# Supporting stuff
# FASD
cwd="$(pwd)"
cd "${HOME}/.local/git/fasd/"
sudo PREFIX=/usr/local/stow/fasd make
sudo PREFIX=/usr/local/stow/fasd make install
cd /usr/local/stow
sudo stow -D fasd
cd "${cwd}"
