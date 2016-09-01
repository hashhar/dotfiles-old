#!/bin/bash
res=$(printf 'Logout|Shutdown|Reboot|Hibernate|Sleep' | rofi -sep '|' -dmenu -i -p 'Power: ' "" -hide-scrollbar -sidebar-mode -i -format i \
                                                             -width 30 -location 3 -padding 5 -opacity 85 \
                                                             -bw 10 -bc "#081f2d" -bg "#081f2d" -fg "#d3ebe9" \
                                                             -hlbg "#195465" -hlfg "#d3ebe9" \
                                                             -font "Droid Sans Mono 14")

case $res in
    0 )
        i3-msg exit ;;
    1 )
        sudo shutdown now ;;
    2 )
        sudo reboot ;;
    3 )
        xautolock -locknow &
        sleep 1
        sudo pm-suspend-hybrid ;;
    4 )
        xautolock -locknow &
        sleep 1
        sudo pm-suspend ;;
esac
exit 0
