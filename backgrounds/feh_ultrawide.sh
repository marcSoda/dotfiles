#!/bin/bash

# Define paths to your wallpapers
laptop="/home/marc/working/dotfiles/backgrounds/other_resolution/03.jpg"
ultrawide="/home/marc/working/dotfiles/backgrounds/5120x1440/07.jpg"

# Define the path for the combined wallpaper
combined_wallpaper="/home/marc/working/dotfiles/backgrounds/TEMP_MERGED.jpg"  # Update this path

# Resize the laptop wallpaper to 1920x1200 if it's not already that size
# The '!'' flag forces the image to the exact size, potentially altering aspect ratio
# Remove '!' if maintaining the aspect ratio is desired, possibly resulting in different dimensions
# convert "$laptop" -resize 1920x1200\! "$laptop"

# Resize the ultrawide wallpaper to 5120x1440 if it's not already that size
convert "$ultrawide" -resize 5120x1440\! "$ultrawide"

# Use ImageMagick to concatenate the images
# This command places the resized laptop image on the left and the resized ultrawide image on the right
convert +append "$laptop" "$ultrawide" "$combined_wallpaper"

# Use feh to set the combined image as the desktop background
feh --no-xinerama --bg-scale --no-fehbg "$combined_wallpaper"
