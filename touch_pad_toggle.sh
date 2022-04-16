#!/bin/sh
#
# Find XINPUT_DEVICE_ID via:
#
#   xinput --list
#
# Update '--icon' paths as needed
#
# gawk -F seperator may need local spacing / tab adjustments, e.g. ':\t' -> ': '

XINPUT_DEVICE_ID=13

if [ $(xinput list-props $XINPUT_DEVICE_ID | grep 'Device Enabled' | gawk -F ':\t' '{ print $2 }') -eq 0 ]; then
  xinput enable $XINPUT_DEVICE_ID
  notify-send --icon=/usr/share/icons/Yaru/scalable/devices/input-touchpad-symbolic.svg "Enabled" "Your computer's touchpad is enabled."
else
  xinput disable $XINPUT_DEVICE_ID
  notify-send --icon=/usr/share/icons/Yaru/scalable/status/touchpad-disabled-symbolic.svg "Disabled" "Your computer's touchpad is disabled."
fi

