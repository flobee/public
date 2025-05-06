# 2FA via CLI

Example:

    2fa ~/.mysecrets/provider-xy

Output:

    # Your code for 'provider-xy' **Code copied to clipboard**
    123456

Where `provider-xy` may be `you@email.tld` to login incl. 2FA code.



<!-- npm install doctoc -->
<!-- doctoc --title '## Table of contents' --entryprefix '+' ./THISFILE -->
<!-- ### -->
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of contents

+ [Requirements](#requirements)
+ [Setup](#setup)
    + [Key generation](#key-generation)
    + [TOTP or SHARED_SECRET handling](#totp-or-shared_secret-handling)
+ [Usage](#usage)
+ [Source/ License](#source-license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## Requirements

+ bash
+ gnupg2 (here `gpg` command ment as `gpg2` command (See config))
+ oathtool
+ Optional: xclip


Install:

    apt install bash gnupg2 oathtool xclip

or without xclip program

    apt install bash gnupg2 oathtool



## Setup

Copy `2fa-config.sh-dist` to `2fa-config.sh` and edit to fit your needs.


### Key generation

You have not a gnupg cert to encrypt a SHARED_SECRET or some other text to be secret
to avoid it stays as plaintext file on FS, USB Stick... whatever?

If not, create one as follow:

    # which asks all questions, e.g. for a 4096 rsa key, never expires
    gpg --full-gen-key

    # shows e.g uid and kid
    gpg --list-secret-keys --keyid-format LONG
    gpg --list-keys

    # Rollout to other maschines.
    # When export and import the private and public key, make sure to set the
    # trust of the keys again on the another computer:
    # <https://unix.stackexchange.com/questions/184947/how-to-import-secret-gpg-key-copied-from-one-machine-to-another>
    gpg --export ${KEY} > public.key
    gpg --export-secret-key ${KEY} > private.key

    # Other computer:
    gpg --import private.key
    gpg --import public.key

    gpg --edit-key {KEY} trust quit
    # enter 5<RETURN> (I trust ultimately)
    # enter y<RETURN> (Really set this key to ultimate trust - Yes)
    # verify that key is now trusted with [ultimate] instead of [unknown]:
    gpg --list-keys


### TOTP or SHARED_SECRET handling

Have a new totp or SHARED_SECRET for 2FA?

    # SERVICE_DIR_2FA from `2fa-config.sh` to be used.
    cd ~/path/to/2FA-service-dirs # or ~/.2fa or ~/.mysecrets/

    # 'YourNewNameForTheUsage' as 'service' name:
    # eg. 2FA code for your you@mail.tld account: mkdir you@mail.tld
    mkdir YourNewNameForTheUsage

    # Open your editor and past the code to be saved at: `.../YourNewNameForTheUsage/.key`
    # otherwise (if cli history is not tracked):
    echo -n 'SHARED_SECRET' > YourNewNameForTheUsage/.key

    # encrypt the SHARED_SECRET
    ./2fa-EncryptSharedSecret.sh ~/path/to/2FA-service-dirs/YourNewNameForTheUsage

    # After: Allow removing the .key file **to not leave it there in plaintext**.

done.

Use 2fa-GetCode.sh to get a 2FA token/ number to use within a loging using
2FA at the provider.



## Usage

    DE-CRYPT = 2fa-GetCode.sh
    EN-CRYPT = 2fa-EncryptSharedSecret.sh

Maybe symlink 2fa-GetCode.sh -> 2fa to your $PATH for easy & daily usage.
Then eg: `2fa ~/.mysecrets/provider-xy` can be used.

    # Using it for authentification
    2fa-GetCode.sh /path/to/serviceDir

You may also symlink `2fa-EncryptSharedSecret.sh` to your $PATH to encrypt new
services. The `2fa-config.sh` must be -here- where these files are (or in
$PATH).

    # Adding and encrpt a new service secret
    2fa-EncryptSharedSecret.sh /path/to/serviceDir/NEW_SERVICE_PATH/

Note: When not in $PATH the usage would be, e.g:
`~/path/to/where/2fa-EncryptSharedSecret.sh ~/path/to/SERVICE_DIR/SERVICE_NAME`



## Source/ License

The scripts here are modified and renamed.

Based on sources and documentation from:
[https://www.cyberciti.biz/faq/use-oathtool-linux-command-line-for-2-step-verification-2fa/]
