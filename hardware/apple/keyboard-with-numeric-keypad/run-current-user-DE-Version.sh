#!/bin/sh

# Helper:
# > xev | grep keycode
#
# https://wiki.archlinux.org/index.php/xmodmap
#
# Scritps belongs to:
# http://flobee.cgix.de/die-apple-tastatur-tastenbelegung-unter-linux-debian-oder-ubuntu/

# configuration file for xmodmap using on debian 8

lc='de';
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

# backup current status for the first usage
if [ ! -f ".xmodmap.initial-usage.bak" ] ;
then
    xmodmap -pke > ".xmodmap.initial-usage.bak";
fi

# sourece generated config file
xmodmap .xmodmap.tmp;


exit;
