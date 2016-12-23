#!/bin/shi
# 
# Helper:
# xev | grep keycode
#
#
# Toggle <> and ^° keys, DE version
# xmodmap \
#    -e 'keycode 49 = less greater less greater bar brokenbar bar' \
#    -e 'keycode 94 = dead_circumflex degree dead_circumflex degree U2032 U2033 U2032'

#
# Have a X Menu on right and left cmd key
xmodmap \
    -e 'keycode 133 = Menu' \
    -e 'keycode 134 = Menu'

