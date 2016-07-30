#!/usr/bin/env bash

# Disable mpd as a system daemon
sudo systemctl stop mpd
sudo systemctl mask mpd

sudo systemctl stop mpd.socket
sudo systemctl mask mpd.socket

# Add a desktop file in ~/.config/autostart to start mpd on login as current user
if [ -d "$HOME/.config/autostart" ]
then
    printf "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=Music Player Daemon\nComment=Server for playing audio files\nExec=mpd\nStartupNotify=false\nTerminal=false\nHidden=false\n" > "$HOME/.config/autostart/mpd.desktop"
else
    mkdir -p "$HOME/.config/autostart"
    printf "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=Music Player Daemon\nComment=Server for playing audio files\nExec=mpd\nStartupNotify=false\nTerminal=false\nHidden=false\n" > "$HOME/.config/autostart/mpd.desktop"
fi

sudo apt-get install mpdscribble

if [ -d "$HOME/.mpdscribble" ]
then
    echo "MPD Scribble configuration exists. Will not overwrite."
else
    mkdir "$HOME/.mpdscribble"
    sudo cp /etc/mpdscribble.conf "$HOME/.mpdscribble/mpdscribble.conf"
    sudo chown "$USER" "$HOME/.mpdscribble/mpdscribble.conf"
fi

sudo systemctl stop mpdscribble
sudo systemctl mask mpdscribble

# Add a desktop file in ~/.config/autostart to start mpdscribble on login as current user
if [ -d "$HOME/.config/autostart" ]
then
    printf "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=MPD Scribble\nComment=Scrobbles files from MPD to Last.fm\nExec=mpdscribble --log ${HOME}/.mpdscribble/log --conf ${HOME}/.mpdscribble/mpdscribble.conf\nStartupNotify=false\nTerminal=false\nHidden=false\n" > "$HOME/.config/autostart/mpdscribble.desktop"
else
    mkdir -p "$HOME/.config/autostart"
    printf "[Desktop Entry]\nEncoding=UTF-8\nType=Application\nName=MPD Scribble\nComment=Scrobbles files from MPD to Last.fm\nExec=mpdscribble --log ${HOME}/.mpdscribble/log --conf ${HOME}/.mpdscribble/mpdscribble.conf\nStartupNotify=false\nTerminal=false\nHidden=false\n" > "$HOME/.config/autostart/mpdscribble.desktop"
fi
