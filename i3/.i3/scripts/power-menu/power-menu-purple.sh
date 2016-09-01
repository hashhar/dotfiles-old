#!/bin/bash
res=$(printf 'Logout|Shutdown|Reboot|Hibernate|Sleep' | rofi -sep '|' -dmenu -i -p 'Power: ' "" -hide-scrollbar -sidebar-mode -i -format i \
                                                             -width 30 -location 3 -padding 5 -opacity 85 \
                                                             -bw 10 -bc "#1d162a" -bg "#1d162a" -fg "#ffffff" \
                                                             -hlbg "#3a2d4e" -hlfg "#ffffff" \
                                                             -font "Droid Sans Mono 14")

case $res in
    0 )
        i3-msg exit ;;
    1 )
        exec sudo shutdown now ;;
    2 )
        exec sudo reboot ;;
    3 )
        exec xautolock -locknow &
        sleep 1
        exec sudo pm-suspend-hybrid ;;
    4 )
        exec xautolock -locknow &
        sleep 1
        exec sudo pm-suspend ;;
esac
exit 0
