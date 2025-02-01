#!/bin/dash

getFile() {
    basename "$1";
}

getFileName() {
    basename "${1%.*}";
}

getFileExtension() {
    echo "${1##*\.}";
}

getFileDirectory() {
    dirname "$1";
}

# @param string $1 Loction to a file
# @returns True if file exists and is a regular file.
fileExists() {
    if [ -f "$1" ]; then
        return 0;
    else
        return 1;
    fi
}

dirExists() {
    if [ -f "$1" ]; then
        return 0;
    else
        return 1;
    fi
}
