#!/bin/sh

# for this rpi: if usb is down only one line for the hub exists:

test `lsusb -t | wc -l` -gt 1 && echo 1 || echo 0
