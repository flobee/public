#!/bin/sh

#
# vcgencmd measure_volts <code>
# 
# Shows voltage. "code" could be one of "core", "sdram_c", "sdram_i", "sdram_p"
#

for nfo in core sdram_c sdram_i sdram_p ; do
    echo "$(vcgencmd measure_volts $nfo) $nfo";
done
