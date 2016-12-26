#!/bin/sh

# configuration file for xmodmap using on debian 8

# Helper:
# https://wiki.archlinux.org/index.php/xmodmap
#
# xev | grep keycode


# Have a X Menu on right and left cmd key
# keycode 133 = Menu
# keycode 134 = Menu'


# toggle from QWERTY to QWERTZ so Z vs. Y
xmodmap \
    -e 'keycode 29 = z Z z Z z Z z Z' \
    -e 'keycode 52 = y Y y Y y Y y Y' \


# euro sign at the e and q key using right alt key (alt-gr)
xmodmap \
    -e 'keycode 24 = q Q EuroSign cent EuroSign cent EuroSign cent' \
    -e 'keycode 26 = e E EuroSign cent EuroSign cent EuroSign cent'


# umlaute
# keycode 30 = u U udiaeresis Udiaeresis udiaeresis Udiaeresis
# keycode 32 = o O odiaeresis Odiaeresis odiaeresis Odiaeresis
# keycode 38 = a A adiaeresis Adiaeresis adiaeresis Adiaeresis




