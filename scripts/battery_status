#!/bin/sh

# A dwm_bar function to read the battery level and status
# Influenced by Joe Standring <git@joestandring.com>

battery_status () {
    # Change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1
    CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    printf "%s" "$SEP1"
    if [ "$STATUS" = "Charging" ]; then
	printf "  %s%%" "$CHARGE"
    else
	if [ $CHARGE -ge 80 ]; then
	    printf " %s%%" "$CHARGE"
	elif [ $CHARGE -ge 60 ] && [ $CHARGE -lt 80 ]; then
	    printf " %s%%" "$CHARGE"
	elif [ $CHARGE -ge 40 ] && [ $CHARGE -lt 60 ]; then
	    printf " %s%%" "$CHARGE"
	elif [ $CHARGE -ge 20 ] && [ $CHARGE -lt 40 ]; then
	    printf " %s%%" "$CHARGE"
	else
	    printf " %s%%" "$CHARGE"
	fi
    fi
    printf "%s\n" "$SEP2"
}

battery_status
