[[ -f ~/.bashrc ]] && . ~/.bashrc
#Only run startx if on tty1
[ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && exec startx
