#!/bin/bash

Dir="/home/ashhar/Pictures/backgrounds/Desktop/Resort"

if [ ! -d "$Dir" ]; then
    echo "Not Exist $Dir"
    exit 1
fi

SetBG () {
TotalFiles=$( ls -R -1 "$Dir" | wc -l )
RandomNumber=$(( $RANDOM % $TotalFiles ))
test ! $RandomNumber = 0 || RandomNumber=1

RandomFile="$( ls -R -1 $Dir | head -n $RandomNumber | tail -n 1)"

#echo "Selected File: $RandomFile"
feh --bg-max "${Dir%/}/${RandomFile}"
}

if [ -f "/tmp/random_wall.lock" ]; then
    SetBG
    exit 1
fi

touch /tmp/random_wall.lock

while true; do
    SetBG
    sleep 3600
    rm /tmp/random_wall.lock
    touch /tmp/random_wall.lock
done
