[[ -f ~/.bashrc ]] && . ~/.bashrc
#Only run startx if on tty1
#[ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && exec startx

# Had to comment out above because $XDG_VTNR stopped being set for some reason
[ -z "$DISPLAY" ] && exec startx
