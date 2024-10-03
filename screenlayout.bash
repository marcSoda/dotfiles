#!/bin/bash

# Define the paths to the xmobar configuration files
xmobar_laptop="/home/marc/working/dotfiles/xmobar/xmobarrc_laptop"
xmobar_external="/home/marc/working/dotfiles/xmobar/xmobarrc_external"
# Define the path to the symlink that xmobar reads
xmobar_link="/home/marc/working/dotfiles/xmobar/xmobarrc"

# Function to update the symlink based on the connected monitor and restart XMonad if the symlink changes
update_xmobar_symlink() {
    local target=$1
    local current_target=$(readlink "$xmobar_link")

    if [ "$current_target" != "$target" ]; then
        # Remove the existing symlink only if it's not pointing to the correct target
        rm -f "$xmobar_link"
        # Create a new symlink to the target configuration file
        ln -s "$target" "$xmobar_link"
        # Restart XMonad to apply the change
        xmonad --restart
    fi
}

# this gets the connected monitor that is not eDP-1. it assumes there is only one other connected monitor
get_connected_monitor() {
  connected_monitor=$(xrandr --query | grep -w "connected" | grep -v "eDP-1" | awk '{print $1}' | head -n 1)

  if [ -z "$connected_monitor" ]; then
    echo "No connected monitor found" >&2
    exit 1
  else
    echo "$connected_monitor"
  fi
}

set_5120x1440() {
  # Add 5120x1440 mode. 60hz
  xrandr --newmode "5120x1440_60"  623.65  5120 5488 6048 6976  1440 1441 1444 1490  -HSync +Vsync > /dev/null 2>&1
  # Add the mode to the found monitor
  xrandr --addmode "$1" 5120x1440_60

  # Apply the desired configuration, turning off all other displays not explicitly mentioned
  xrandr --output eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal \
         --output "$1" --primary --mode 5120x1440_60 --pos 1920x0 --rotate normal > /dev/null 2>&1
  ~/working/dotfiles/backgrounds/feh_ultrawide.sh
}

del_virt_monitors() {
  xrandr --delmonitor LeftSide > /dev/null 2>&1
  xrandr --delmonitor Center > /dev/null 2>&1
  xrandr --delmonitor RightSide > /dev/null 2>&1
}

# Ensure a clean slate by deleting virtual monitors
del_virt_monitors


if [ "$1" = "res" ]; then
  xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal
  # Get the list of connected outputs, excluding eDP-1 and disconnected outputs
  other_outputs=$(xrandr --query | grep ' connected' | grep -v 'eDP-1' | cut -d ' ' -f1)
  # Loop through each output and turn it off
  for output in $other_outputs; do
    xrandr --output "$output" --off
  done
  ~/working/dotfiles/backgrounds/feh_laptop.sh
  echo "laptop" > /tmp/monitor_state
elif [ "$1" = "sing" ]; then
  connected_monitor=$(get_connected_monitor)
  set_5120x1440 "$connected_monitor"
  echo "external" > /tmp/monitor_state
elif [ "$1" = "dual" ]; then
  connected_monitor=$(get_connected_monitor)
  set_5120x1440 "$connected_monitor"
  xrandr --setmonitor LeftSide 2560/677x1440/381+1920+0 "$connected_monitor" > /dev/null 2>&1
  xrandr --setmonitor RightSide 2560/677x1440/381+4480+0 none > /dev/null 2>&1
  echo "external" > /tmp/monitor_state
elif [ "$1" = "trip" ]; then
  connected_monitor=$(get_connected_monitor)
  set_5120x1440 "$connected_monitor"
  xrandr --setmonitor LeftSide 1280/340x1440/381+1920+0 none > /dev/null 2>&1
  xrandr --setmonitor Center 2560/677x1440/381+3200+0 "$connected_monitor" > /dev/null 2>&1
  xrandr --setmonitor RightSide 1280/340x1440/381+5760+0 none > /dev/null 2>&1
  echo "external" > /tmp/monitor_state
elif [ "$1" = "32" ]; then
  connected_monitor=$(get_connected_monitor)
  xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal \
         --output "$connected_monitor" --mode 2560x1440 --rate 165.08 --pos 1920x0 --rotate normal
  echo "external" > /tmp/monitor_state
else
  echo "Unrecognized command."
fi

# Determine the appropriate xmobar configuration based on monitor connection status
if [ "$(cat /tmp/monitor_state)" = "external" ]; then
    update_xmobar_symlink "$xmobar_external"
else
    update_xmobar_symlink "$xmobar_laptop"
fi
