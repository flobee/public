#!/bin/dash

# see also https://superuser.com/questions/323119/how-can-i-normalize-audio-using-ffmpeg for normalize
# sudo apt-get install ffmpeg python-pip
# pip install ffmpeg-normalize
# For example, to RMS-normalize the audio of every MP4 file to -26 dB, run this:
# ffmpeg-normalize *.mp4

# SYNC with: ~/.local/share/kservices5/ServiceMenus/convert.desktop



# --- functions

usage() 
{
    echo "Usage: $0 [-c compress:0-36] [ -f file ]"
    echo "Optional: "
    echo "    -b  flag: enable batch mode using 'at'"
    echo "    -w  flag: overwrite existing"
#     echo "    -s  suffix for the base filename (e.g. -s HD -> name.ts -> name.HD.mp4)"
    exit 2
}

pause()
{
    _CONFIRMPAUSE='n';
    read -p "Pause. Press <enter> to go ahead" CONFIRMPAUSE
    CONFIRMPAUSE=${CONFIRMPAUSE:-$_CONFIRMPAUSE}

    return 0;
}

# --- checks

unset BATCH COMP NAME OVERWRITE NAMESUFFIX

#while getopts 'bwc:f:s:?h' c
while getopts 'bwc:f:?h' c
do
    case $c in
        b) BATCH=true ;;
        c) COMP=$OPTARG ;;
        f) NAME=$OPTARG ;;
#         s) NAMESUFFIX=$OPTARG ;;
        w) OVERWRITE=true ;;
        h|?) usage ;;
    esac
done


# --- actions


echo "compression: $COMP, name: $NAME; batch?: $BATCH; force overwrite: $OVERWRITE";

[ ! -f "$NAME" ] && echo 'No file' && usage
[ $COMP -lt 0 ] && echo 'comp min invalid' && usage
[ $COMP -gt 36 ] && echo 'comp max invalid' && usage


# if [ "$NAMESUFFIX" != "" ]; then
#     NAME="$NAME.$NAMESUFFIX";
# fi


if [ $BATCH ]; then

    # echo "avconv -i '$NAME' -c:v libx264 -preset slow -crf $COMP -c:a copy '$NAME.$COMP.mp4'" | at now -b;
    if [ ! -f "$NAME.$COMP.mp4" ] || [ $OVERWRITE ]; then
        if [ $OVERWRITE ]; then
            rm -f "$NAME.$COMP.mp4"
        fi
        
        echo "if [ ! -f \"$NAME.$COMP.mp4\" ]; then ffmpeg -i '$NAME' -c:v libx264 -preset slow -crf $COMP -c:a copy '$NAME.$COMP.mp4'; fi" | at now -b;
    else
        echo "# File already found! force to re-create (opt -w)? '$NAME.$COMP.mp4'";
    fi

else

    if [ ! -f "$NAME.$COMP.mp4" ] || [ $OVERWRITE ]; then
        if [ $OVERWRITE ]; then
            rm -f "$NAME.$COMP.mp4"
        fi
        
        # avconv -i "$NAME" -c:v libx264 -preset slow -crf $COMP -c:a copy "$NAME.$COMP.mp4"
        ffmpeg -i "$NAME" -c:v libx264 -preset slow -crf $COMP -c:a copy "$NAME.$COMP.mp4"
    else
        echo "# File already found! force to re-create (opt -w)? '$NAME.$COMP.mp4'";
        pause
    fi
fi

exit 0;
