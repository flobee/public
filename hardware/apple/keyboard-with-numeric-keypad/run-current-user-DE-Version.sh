#!/bin/sh

# Scritps belongs to:
# http://flobee.cgix.de/die-apple-tastatur-tastenbelegung-unter-linux-debian-oder-ubuntu/
#
# Helper:
# > xev | grep keycode
# https://wiki.archlinux.org/index.php/xmodmap
# http://wiki.linuxquestions.org/wiki/List_of_Keysyms_Recognised_by_Xmodmap


# base layout you start on (loads xmodmap.de.cfg file).
lc='de';

. ./run-current-user-base.sh
