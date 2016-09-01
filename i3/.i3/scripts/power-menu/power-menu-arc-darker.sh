#!/bin/bash
res=$(printf 'Logout|Shutdown|Reboot|Hibernate|Sleep' | rofi -sep '|' -dmenu -i -p 'Power: ' "" -hide-scrollbar -sidebar-mode -i -format i \
                                                             -width 30 -location 3 -padding 5 -opacity 85 \
                                                             -bw 10 -bc "#2f343f" -bg "#2f343f" -fg "#f3f4f5" \
                                                             -hlbg "#5c6476" -hlfg "#f3f4f5" \
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
