#!/bin/dash

# Scritps belongs to:
# http://flobee.cgix.de/die-apple-tastatur-tastenbelegung-unter-linux-debian-oder-ubuntu/
#
# Helper:
# > xev | grep keycode
#
# https://wiki.archlinux.org/index.php/xmodmap
# http://wiki.linuxquestions.org/wiki/List_of_Keysyms_Recognised_by_Xmodmap
#



if [ "${lc}" = "" ]] ; then
    echo "Missing language code to use. Exit!"
    exit 1;
fi


# status after a successful execution (config file without comments)
tmpfile=".xmodmap.status.$lc.after";
# status befor last successful execution
backupfile=".xmodmap.status.$lc.befor";
# config file to load the mapping (with comments)
configfile="xmodmap.$lc.cfg";


# execute

if [ -f $configfile ] ;
then
    # drop comments
    sed -e '/^\s*$/d' -e '/^#/d' -e '/^;/d' $configfile > $tmpfile
else
    echo "error: configfile not found";
    exit 1;
fi

# backup current status for the first usage
if [ ! -f ".xmodmap.status-initially.$lc.bak" ] ;
then
    xmodmap -pke > ".xmodmap.status-initially.$lc.bak";
fi

# dump current status of changes to check changes via "git status"
xmodmap -pke > "$backupfile";

# sourece generated config file
xmodmap "$tmpfile";


exit;
