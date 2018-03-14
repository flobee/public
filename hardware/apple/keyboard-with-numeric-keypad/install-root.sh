#!/bin/sh

#
echo "Default changes for apple keyboard with numeric pad, german keyboard";

echo "Run this script when changing or update the kernel to reactivate this";
echo "settings. Note: Settings will be repalaced. Dont edit target file or";
echo "change this script!";

# Toogles F<N> and multimedia keys
# manually: echo 2 > /sys/module/hid_apple/parameters/fnmode
echo "Toogles F<N> and multimedia keys permanetly";
echo 'run: echo "options hid_apple fnmode=2" > /etc/modprobe.d/hid_apple.conf';
echo "options hid_apple fnmode=2" > /etc/modprobe.d/hid_apple.conf


# tauschen der alt + cmd tasten, zwar richtig bezeichnet aber unterschiedlich 
# zur pc tastatur
# cmd: echo 1 > /sys/module/hid_apple/parameters/swap_opt_cmd
# options hid_apple swap_opt_cmd=1


echo 'Update initramfs';
update-initramfs -u -k all;


echo 'Done.';

