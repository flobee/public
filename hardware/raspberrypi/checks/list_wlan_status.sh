#!/bin/sh

# wireless-tools required, probably installed
# shows 1 for connected, 0 for no connection.
# ssh and wpa-supplicant are loaded. switsching off the wlan router will drop 
# the/some lines.

test `iwgetid | wc -l ` -eq 1 && echo 1 || echo 0
