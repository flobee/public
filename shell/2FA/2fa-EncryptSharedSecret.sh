#!/bin/bash
#
# Purpose: Encrypt the totp secret stored in $dir/$service/.key file
# Author: Vivek Gite {https://www.cyberciti.biz/} under GPL v 2.x or above
#
# https://www.cyberciti.biz/faq/use-oathtool-linux-command-line-for-2-step-verification-2fa/
#
#
# Usage:
#
# + Key generation:
#
# Have a gnupg cert to encrypt a SHARED_SECRET to avoid staying as plaintext file on FS?
#
#   # which asks all questions, e.g. for a 4096 rsa key, never expires
#   gpg2 --full-gen-key 
#
#   # shows e.g uid and kid
#   gpg --list-secret-keys --keyid-format LONG   
#   gpg --list-keys
#
#   # When export and import the private and public key, make sure to set the 
#   # trust of the keys again on the another computer:
#   # https://unix.stackexchange.com/questions/184947/how-to-import-secret-gpg-key-copied-from-one-machine-to-another
#   gpg --export ${KEY} > public.key
#   gpg --export-secret-key ${KEY} > private.key
#
#   # Other computer:
#   gpg --import private.key
#   gpg --import public.key
#
#   gpg --edit-key {KEY} trust quit
#   # enter 5<RETURN> (I trust ultimately)
#   # enter y<RETURN> (Really set this key to ultimate trust - Yes)
#   # verify that key is now trusted with [ultimate] instead of [unknown]:
#   gpg --list-keys
#
#
# + TOTP handling:
#
# Have a new totp key (SHARED_SECRET) for 2FA?
#   cd ~/path/to/2FA-service-dirs # or ~/.2fa
#
#   # 'YourNewNameForTheUsage' as 'service' name:
#   # eg. 2FA code for your mail@gmail.com account: mkdir mail@gmail.com
#   mkdir YourNewNameForTheUsage
#   echo -n 'SHARED_SECRET' > YourNewNameForTheUsage/.key
#
#   # encrypt the SHARED_SECRET
#   ./2fa-EncryptSharedSecret.sh ~/path/to/2FA-service-dirs/YourNewNameForTheUsage
#   # After: Allow removing the .key file to not leave it there in plaintext.
# done.
#
# Use 2fa-GetCode.sh to get a 2FA token/ number to use within a loging using
# 2FA at the provider


# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname "$(readlink -f "$0")")";
. "${DIR_OF_FILE}"/2fa-config.sh;
# ---------------------------------------------------------------------

# build CLI args
serviceDir=$(basename "$1")
k="${SERVICE_DIR_2FA}/${serviceDir}/.key"
kg="${k}.gpg"

# failsafe stuff
[ "$1" == "" ] && { echo "Usage: $0 service"; exit 1; }
[ ! -f "$k" ] && { echo "$0 - Error: $k file not found. Already encrypted?"; exit 2; }
[ -f "$kg" ] && { echo "$0 - Error: Encrypted file \"$kg\" exists."; exit 3; }

# Encrypt your service .key file
$BIN_GPG2 -u "${KID_KEY}" -r "${UID_KEY}" --encrypt "$k" && rm -i "$k"
