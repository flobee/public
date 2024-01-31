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
# DIR_OF_FILE="$(dirname "$0")";
# echo "dir:"$DIR_OF_FILE;
# echo '$0' $0;
if [ -L "$0" ] ; then
   if [ -e "$0" ] ; then
      DIR_OF_FILE="$(dirname "$0")";
   else
      echo "Broken link to '$0'"
      exit 1;
   fi
elif [ -e "$0" ] ; then
   DIR_OF_FILE="$(dirname "$(readlink -f "$0")")";
else
   echo "Missing link or file to get the config"
   exit 1;
fi
if [ ! -f "${DIR_OF_FILE}/2fa-config.sh" ]; then
    echo 'Please configure "2fa-config.sh" first';
    exit 1;
fi
. "${DIR_OF_FILE}"/2fa-config.sh;
# ---------------------------------------------------------------------

# Build CLI arg
s=$(basename "$1")
k="${SERVICE_DIR_2FA}/${s}/.key"
kg="${k}.gpg"

# failsafe stuff
[ "$1" == "" ] && { echo "Usage: $0 service"; exit 1; }
[ ! -f "$kg" ] && { echo "Error: Encrypted file \"$kg\" not found."; exit 2; }

# Get totp secret for given service
totp=$($BIN_GPG2 --quiet -u "${KID_KEY}" -r "${UID_KEY}" --decrypt "$kg")
# For debugging, decryption of the shared secret:
#echo "$totp";

# Generate 2FA totp code and display on screen
echo -n "# Your code for '$s' "
code=$($BIN_OATHTOOL -b --totp "$totp")
## Copy to clipboard too ##
## if xclip command found  on Linux system ##
type -a xclip &>/dev/null
[ $? -eq 0 ] && { echo -n "$code" | xclip -sel clip; echo "**Code copied to clipboard**"; }
echo "$code"

# Make sure we don't have .key file in plain text format ever #
[ -f "$k" ] && echo "Warning - Plain text key file \"$k\" found."
