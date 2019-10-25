# Model PI3 a02082

# Power management hints

Some tests to cool down the power usage with minimum of action or harware changes.

For this rpi it seems only the four usb ports can be de/activated.

Wlan is still up when disabling usb ports,
eth will be OFF when powering down for this raspberry version!

Switching off usb frees usage of ~110mA on my rpi.
 - Iddle (AC Adapter)  : 5.23V / 270mA, usb off: ~150mA 
   => 24h messurement: ~22W (While playing around with it)
 - Iddle (DC Powerbank): 5.04V / 268mA, usb off: ~153mA

If ssh and wpa supplicant are still loaded but just the WLAN connection is off 
(switching off at the wlan router) it saves ~30mA
So the PI3 can run in iddle mode using ~120-130mA without doing hard things to 
limit the power usage.

Its a good reason to diable usb it when not needed :)
