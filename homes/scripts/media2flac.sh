#!/bin/dash

usage()
{
    echo "Usage: $0 [-c compress:0-8] [ -f file ]"
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

    if [ ! -f "$NAME.$COMP.flac" ] || [ $OVERWRITE ]; then
        if [ $OVERWRITE ]; then
            rm -f "$NAME.$COMP.flac"
        fi

        echo "if [ ! -f \"$NAME.$COMP.flac\" ]; then ffmpeg -i '$NAME' -acodec flac -aq $COMP '$NAME.$COMP.flac'; fi" | at now -b;
    else
        echo "# File already found! force to re-create (opt -w)? '$NAME.$COMP.flac'";
    fi

else

    if [ ! -f "$NAME.$COMP.flac" ] || [ $OVERWRITE ]; then
        if [ $OVERWRITE ]; then
            rm -f "$NAME.$COMP.flac"
        fi

        ffmpeg -i "$NAME" -acodec flac -aq $COMP "$NAME.$COMP.flac"
        #ffmpeg -i "$NAME" -c:v libx264 -preset slow -crf $COMP -c:a copy "$NAME.$COMP.mp4"
    else
        echo "# File already found! force to re-create (opt -w)? '$NAME.$COMP.flac'";
        pause
    fi
fi

exit 0;
