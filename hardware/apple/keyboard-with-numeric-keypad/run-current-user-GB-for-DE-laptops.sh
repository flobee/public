#!/bin/sh

# Scritps belongs to:
# http://flobee.cgix.de/die-apple-tastatur-programmierertauglich-gemacht-gb4de

# base layout you start on (loads xmodmap.gb4de.cfg file).
lc='gb4de';

mypath=`dirname "$0"`;

cd $mypath;

. ./run-current-user-base.sh

