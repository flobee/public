#!/bin/dash

###
# manager to scan a directory and execute ./audioNormalize.sh
# to convert/ normalize audio files using (probably) sox
#

SCRIPT_DIRECTORY_REAL="$(dirname "$(readlink -f "$0")")";
# SCRIPT_FILENAME_REAL="$(basename "$(readlink -f "$0")")";
# SCRIPT_FILENAME_CURRENT=$(basename "$0");

DIR="";
if [ -d "$1" ]; then
    DIR="$1";
    # echo "Directory found: '$1'";
else
    echo "Directory not found: '$1'";
    exit 1;
fi

contains() {
    if [ "$1" ] &&              # Is there a source string
       [ "$2" ] &&              # Is there a substring
       [ -z "${1##*"$2"*}" ];   # Test substring in source
    then
        return 0;
    else
        return 1;
    fi;
}


for FILE in $(command ls "$DIR"); do
    FILE_EXTENSION="${FILE##*\.}";

    if [ -f "$DIR/$FILE" ] &&
        [ "$FILE_EXTENSION" = "mp3" ] &&
        ! contains "$FILE" "_norm.mp3";
    then
        # echo "X: $FILE\n";
        "$SCRIPT_DIRECTORY_REAL/audioNormalize.sh" "$DIR/$FILE";
    fi
done;


