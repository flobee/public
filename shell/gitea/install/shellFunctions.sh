#!/bin/sh

confirmCommand() {
    default="$1";
    if [ "${default}" = "" ] || [ "${default}" = "N" ]; then
        _CONFIRMCOMMAND='n';
    else
        _CONFIRMCOMMAND=${default};
    fi
    read -p "Confirm (Y)es,(n)o (def:'$_CONFIRMCOMMAND'): " CONFIRMCOMMAND
    CONFIRMCOMMAND=${CONFIRMCOMMAND:-$_CONFIRMCOMMAND}

    return 0;
}
