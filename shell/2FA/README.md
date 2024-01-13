# 2FA via shell

Example:

    2fa ~/.mysecrets/provider-xy

Output:

    # Your code for 'provider-xy' **Code copied to clipboard**
    123456

Where `provider-xy` may be `you@email.tld` to login incl. 2FA



## Requires:

+ gnupg2
+ oathtool
- Optional: xclip

`apt install gnupg2 oathtool`



## Setup

Copy `2fa-config.sh-dist` to `2fa-config.sh` and edit to fit your needs.


### Key generation

You have not a gnupg cert to encrypt a SHARED_SECRET to avoid it stays as
plaintext file on FS, USB Stick... whatever? If not create one as follow:

    # which asks all questions, e.g. for a 4096 rsa key, never expires
    gpg2 --full-gen-key

    # shows e.g uid and kid
    gpg --list-secret-keys --keyid-format LONG
    gpg --list-keys

    # Rollout to other maschines.
    # When export and import the private and public key, make sure to set the
    # trust of the keys again on the another computer:
    # https://unix.stackexchange.com/questions/184947/how-to-import-secret-gpg-key-copied-from-one-machine-to-another
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


### TOTP/ SHARED_SECRET handling

Have a new totp key (SHARED_SECRET) for 2FA?

    # SERVICE_DIR_2FA from `2fa-config.sh` to be used.
    cd ~/path/to/2FA-service-dirs # or ~/.2fa or ~/.mysecrets/

    # 'YourNewNameForTheUsage' as 'service' name:
    # eg. 2FA code for your you@mail.tld account: mkdir you@mail.tld
    mkdir YourNewNameForTheUsage
    echo -n 'SHARED_SECRET' > YourNewNameForTheUsage/.key # Or use your editor to add it.

    # encrypt the SHARED_SECRET
    ./2fa-EncryptSharedSecret.sh ~/path/to/2FA-service-dirs/YourNewNameForTheUsage
    # After: Allow removing the .key file to not leave it there in plaintext.

done.

Use 2fa-GetCode.sh to get a 2FA token/ number to use within a loging using
2FA at the provider.



## Usage

Maybe symlink 2fa-GetCode.sh -> 2fa to your $PATH for easy & daily usage. Then
eg: `2fa ~/.mysecrets/provider-xy` can be used.

    # Using it for authentification
    2fa-GetCode.sh /path/to/serviceDir

You may also symlink `2fa-EncryptSharedSecret.sh` to your $PATH.
The `2fa-config.sh` must be -here- where these files are.

    # Adding and encrpt a new service secret
    2fa-EncryptSharedSecret.sh /path/to/serviceDir/NEWLY_CREATED_PATH/AND_PLAINTEXT_KEYFILE



## Sources

Based on sources and documentation from:
(https://www.cyberciti.biz/faq/use-oathtool-linux-command-line-for-2-step-verification-2fa/)
