#!/bin/dash

# sox --norm src.mp3 target.mp3 # works for normalize, audacity does better!
#for f in *.mp3; do sox --norm "$f" /tmp/sox.mp3; mv -v /tmp/sox.mp3 "$f"; done

SCRIPT_DIRECTORY_REAL="$(dirname "$(readlink -f "$0")")";
SCRIPT_FILENAME_REAL="$(basename "$(readlink -f "$0")")";
SCRIPT_FILENAME_CURRENT=$(basename "$0");

CONVERTER_BIN=/usr/bin/sox

#kdialog --title "$SCRIPT_FILENAME_REAL" --msgbox "File: $1"



FILE="";
if [ -f "$1" ]; then
    FILE="$1";
else
    echo "File not found: '$1'";
    exit 1;
fi

FILE_EXTENSION="${FILE##*\.}";
FILE_NAME=$(basename "${FILE%.*}");
FILE_DIR=$(dirname "$FILE");

FILE_TARGET_LOC="$FILE_DIR/$FILE_NAME""_norm.$FILE_EXTENSION"

if [ "$FILE_EXTENSION" != "mp3" ]; then
    echo "Wrong file extension. Only for 'mp3'";
    exit 1;
fi


###
# @param string $1 Command to be checked
checkCommandAvailable() {
    if ! command -v "$1"; then
        echo "Command '$1' not available.";

        return 1;
    fi

    return 0;
}

# echo "$FILE_NAME"
# echo "$FILE_EXTENSION"
# echo "$FILE";
# echo "$FILE_DIR";

if ! checkCommandAvailable "$CONVERTER_BIN" >/dev/null 2>&1; then
    echo "Please install '$CONVERTER_BIN'. E.g: apt install $CONVERTER_BIN";

    exit 1;
fi

if [ ! -f "$FILE_TARGET_LOC" ]; then
    $CONVERTER_BIN --norm "$FILE" "$FILE_DIR/$FILE_NAME""_norm.$FILE_EXTENSION";
    # echo "$FILE_TARGET_LOC";
fi