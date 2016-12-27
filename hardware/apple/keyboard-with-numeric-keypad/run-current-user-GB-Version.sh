#!/bin/sh

# Helper:
# https://wiki.archlinux.org/index.php/xmodmap
#
# xev | grep keycode
#
# Have a X Menu on right and left cmd key
# keycode 133 = Menu
# keycode 134 = Menu'
#
# configuration file for xmodmap using on debian 8

lc='GB';
tmpfile='.xmodmap.tmp';
configfile="xmodmap.$lc.cfg";


if [ -f $configfile ] ;
then
    # drop comments
    sed -e '/^\s*$/d' -e '/^#/d' -e '/^;/d' $configfile > $tmpfile
else
    echo "error";
fi

# sourece generatet config file
xmodmap .xmodmap.tmp


exit;
