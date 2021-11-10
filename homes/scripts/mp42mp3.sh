#/bin/sh

# mp4 to mp3 convert using ffmpeg max quality
# hints: https://www.fosslinux.com/44788/how-to-convert-mp4-to-mp3-in-linux.htm
# check helper in .shell_functions

FILE_IN=$1;

if [ "${FILE_IN}" = "" ]; then
    echo "Input file location missing";
    exit 1;
fi

ffmpeg -i "${FILE_IN}" -b:a 320K -vn "${FILE_IN}.320k.mp3"

