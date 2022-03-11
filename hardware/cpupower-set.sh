#/bin/sh

# set cpu frequency by a governor code based on debian package 'linux-cpupower'
# https://manpages.debian.org/testing/linux-cpupower/cpupower-frequency-set.1.en.html

governor="$1";

if [ "$(id -u)" -ne 0 ] ; then
    echo "cpupower-set.sh: Please run as root" ;
    exit 1;
fi


if [ "$governor" = "" ]; then
    echo 'cpupower-set.sh [performance|powersave]';
    exit 1;
fi

if [ "$governor" = 'performance' ] ; then
    cpupower --cpu all frequency-set -g performance --min 0.8GHz --max 3.8GHz # works cpu performance
else
    cpupower --cpu all frequency-set -g powersave --min 0.8GHz --max 1.2GHz # works cpu powersave
fi
