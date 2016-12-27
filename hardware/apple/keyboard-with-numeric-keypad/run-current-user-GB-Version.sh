#!/bin/sh

# Helper:
# > xev | grep keycode
#
# https://wiki.archlinux.org/index.php/xmodmap
#


# configuration file for xmodmap using on debian 8

lc='gb';
tmpfile='.xmodmap.tmp';
configfile="xmodmap.$lc.cfg";


if [ -f $configfile ] ;
then
    # drop comments
    sed -e '/^\s*$/d' -e '/^#/d' -e '/^;/d' $configfile > $tmpfile
else
    echo "error: configfile not found";
    exit 1;
fi

# sourece generated config file
xmodmap .xmodmap.tmp


exit;
