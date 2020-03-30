#!/bin/sh

# Shows the core temperature of BCM2835 SoC.
#vcgencmd measure_temp
# e.g: temp=42.9'C

# outputs float value:
tempRaw=`vcgencmd measure_temp`
temp=`echo $tempRaw | tr -d \'C | cut -d '=' -f2`
echo $temp;
