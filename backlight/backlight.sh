#!/bin/bash
backlightPath="/sys/class/backlight/intel_backlight/"
brightnessPath="$backlightPath/brightness"
maximum_brightnessPath="$backlightPath/max_brightness"
current_brightness=$(<"$brightnessPath")
maximum_brightness=$(<"$maximum_brightnessPath")
brightnessChange="$1"
is_number='^-?[0-9]+$'
if ! [[ $# -gt 0 && "$brightnessChange" =~ $is_number ]]; then
	echo "Not a valid number provided as first argument, exiting..."
	exit 1
fi
goalbrightness=$(( current_brightness + brightnessChange ))
if [ $goalbrightness -gt "$maximum_brightness" ]; then
	echo $maximum_brightness > "$brightnessPath"
elif [ $goalbrightness -lt 0 ]; then
	echo 0 > "$brightnessPath"
else
	echo $goalbrightness > "$brightnessPath"
fi
