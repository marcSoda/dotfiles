[[ -f ~/.bashrc ]] && . ~/.bashrc
#init .xinitrc
[ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && exec startx
