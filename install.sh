#!/usr/bin/env sh

#modules=$(find . -maxdepth 1 -type d \! -path "./.git" \! -path "\." -printf '%f\n')
#
#for module in ${modules}; do
#	stow -R ${module}
#	if [ "${module}" == "bash" ]; then
#		sudo stow -R --target=/root ${module}
#	fi
#done

git submodule init
git submodule update

# Bash (for current user and root user)
stow -R bash
sudo stow -R -t /root bash

# BitDay wallpapers
stow -R BitDay
crontab -l > cron.install
sed -i '/BitDay/d' cron.install
printf "# BitDay wallpaper rotation\n0        *       *       *       *       ${HOME}/.config/BitDay/change.sh\n@reboot                                  ${HOME}/.config/BitDay/change.sh\n" >> cron.install
crontab cron.install
#rm cron.backup

# Cava
stow -R cava

# Fonts
stow -R fonts
fc-cache -f

# Custom binary scripts
stow -R magic-bin

# MPD
stow -R mpd

# Nano syntax highlight files
stow -R nano

# ncmpcpp
stow -R ncmpcpp

# Redshift GTK
stow -R redshift

# Supporting stuff
# FASD
cwd="$(pwd)"
cd "${HOME}/.local/git/fasd/"
sudo PREFIX=/usr/local/stow/fasd make
sudo PREFIX=/usr/local/stow/fasd make install
cd /usr/local/stow
sudo stow -R fasd
cd "${cwd}"
