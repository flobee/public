#!/bin/dash

if [ "$1" = "" ]; then
    echo '+------------------------------------+';
    echo "ts2mpg [$1]";
    echo 'ffmpeg -i "$1" -target pal-dvd -qscale 0 "$1.mpg"';
    echo '+------------------------------------+';
    exit 1;
fi

echo $0;
echo $1;
echo $2;


if [ "$2" = "-b" ]; then
    echo "$0 $1" | at now -b 
else
    ffmpeg -i "$1" -target pal-dvd -qscale 0 "$1.mpg"            
fi

exit;
