#!/bin/bash

# Read info in services_.sh script

SCRIPT_DIRECTORY_REAL="$(dirname "$(readlink -f "$0")")";

# source all the rest from there
if [ -f "$SCRIPT_DIRECTORY_REAL/services_.sh" ]; then
    # shellcheck disable=SC1091
    source "$SCRIPT_DIRECTORY_REAL/services_.sh";
fi

