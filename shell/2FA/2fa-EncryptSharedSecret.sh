#!/bin/bash
# ---------------------------------------------------------------------
# Purpose: Encrypt the totp secret stored in $dir/$service/.key file
# Author: Vivek Gite {https://www.cyberciti.biz/} under GPL v 2.x or above
#
# https://www.cyberciti.biz/faq/use-oathtool-linux-command-line-for-2-step-verification-2fa/
#
# Fork and extended by flobee //github.com/flobee/public/shell/2FA/
#
# ---------------------------------------------------------------------

# TODO: DIR of file to get the README in error message


if [ -L "$0" ] ; then
    if [ -e "$0" ] ; then
        DIR_OF_FILE="$(dirname "$0")";
    else
        echo "Broken link or file to '$0'"
        exit 1;
    fi
elif [ -e "$0" ] ; then
    DIR_OF_FILE="$(dirname "$(readlink -f "$0")")";
else
    echo "Missing link or file to get the config"
    exit 1;
fi

if [ ! -f "${DIR_OF_FILE}/2fa-config.sh" ]; then
    echo 'Please configure "2fa-config.sh" first where you use the 2fa-* scripts (PATH or direct calls)';
    exit 1;
fi

# shellcheck disable=SC1091
. "${DIR_OF_FILE}"/2fa-config.sh;
# ---------------------------------------------------------------------

# build CLI args
serviceDir=$(basename "$1")
k="${SERVICE_DIR_2FA}/${serviceDir}/.key"
kg="${k}.gpg"

# failsafe stuff
[ "$1" == "" ] && {
    echo "Usage: $0 serviceDirectory";

    exit 1;
}

[ ! -f "$k" ] && {
    echo "$0 - Error: $k file not found."
    echo "Already encrypted? Expecting 'serviceDir/.key' plaintext file to go on.";

    exit 1;
}

[ -f "$kg" ] && {
    echo "$0 - Error: Encrypted file \"$kg\" exists. Abort";

    exit 1;
}

# Encrypt your service .key file
$BIN_GPG2 -u "${KID_KEY}" -r "${UID_KEY}" --encrypt "$k";

echo "The key file is now encrypted (If you dont see any errors)."
echo "Now you can safely remove the plain text file '${serviceDir}/.key'";
echo "Answer with 'y' or 'yes' to do so.";

rm -i "$k"
