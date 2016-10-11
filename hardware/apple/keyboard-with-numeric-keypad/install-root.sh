#!/bin/sh

#
# Toogle F<N> and multimedia keys
#
echo "options hid_apple fnmode=2" >> /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all


