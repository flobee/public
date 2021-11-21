#!/bin/sh


# ---------------------------------------------------------------------
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


# ---------------------------------------------------------------------
sourceConfigs() {
    LOCATION=$1;        # Path where to load config files (eg: '/tmp/')
    CONFIG_DIST=$2;     # Name of the config of the distribution (default values; e.g: 'config.sh-dist')
    CONFIG_CUSTOM=$3;   # Name of your custom confif to overwrite defaults (e.g: 'config.sh')

    if [ -f "${LOCATION}/${CONFIG_DIST}" ]; then
        . "${LOCATION}/${CONFIG_DIST}";
    else
        echo "Default config not found: '${LOCATION}/${CONFIG_DIST}'";
    fi

    if [ -f "${LOCATION}/${CONFIG_CUSTOM}" ]; then
        . "${LOCATION}/${CONFIG_CUSTOM}";
    # else
        #echo "Custom config not found: '${LOCATION}/${CONFIG_CUSTOM}'";
    fi
}
