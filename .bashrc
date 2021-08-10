#!/bin/bash

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

#Add ls colors
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

#set editor
export EDITOR=emacs

#set external display
export EXTERNAL_DISPLAY=DP1

#aliases:

#system
alias c='clear'
alias pacman='sudo pacman'
alias grep='grep --color=auto'
alias ls='lsd -lAF --group-dirs=last --color=always'
alias rm='rm -v'

#bluetooth
alias btc='bluetoothctl'
alias pods='btc power on && btc connect AC:90:85:61:CB:FC'
alias buds='btc power on && btc connect F4:7D:EF:4F:43:98'
alias anker='btc power on && btc connect 08:EB:ED:6E:E8:29'
alias keyboard='btc power on && btc connect DC:2C:26:F8:7F:DC'
alias mouse='btc power on && btc connect FA:BE:26:DE:58:81'

#c
alias mg='gcc -g -Wall -Wextra -Wwrite-strings'
alias mg+='g++ -g -Wall -Wextra -Wwrite-strings'

#emacs remote dev using named workspaces
alias ancilla='e -n ancilla /ssh:ancilla:working/'
alias sunlab='e -n sunlab /ssh:masa20@sunlab.cse.lehigh.edu:working'

#emacsclient named workspaces
e() {
    if [ $# -le 1 ]; then               #if no args, start the default daemon that is always running
        emacsclient -s default -t $1
        ret=$?
        if [ $ret != 0 ] && [ $ret != 147 ] ; then
            /usr/bin/emacs --daemon=default
            /usr/bin/emacsclient -s default -nw $1
        fi
    elif [ "$1" = "-n" ]; then         #if -n, make a new named daemon and run it in fg
        /usr/bin/emacs --daemon=$2
        /usr/bin/emacsclient -s $2 -nw $3
    elif [ "$1" = "-o" ]; then         #if -n, make a new named daemon and run it in fg
        /usr/bin/emacsclient -s $2 -nw $3
        if [ $? != 0 ] && [ $? != 147 ] ; then
            /usr/bin/emacs --daemon=$2
            /usr/bin/emacsclient -s $2 -nw $3
        fi
    elif [ "$1" = "-d" ]; then         #if -d, kill named daemon called $2
        /usr/bin/emacsclient -s $2 -e '(save-buffers-kill-emacs)'
    fi
}

#share text to dropbox
tshare() {
    echo "${@:1}" > ~/working/sync/misc/tshare.txt
}

#Custom pass behavior
pass() {
    if [ "$1" = "sync" ]; then
        cd ~/.password-store
        git pull --rebase  && git push
    else
        /usr/bin/pass "$@"
    fi
}

#Used when a display is connected to DP-1
doc() {
    if [ "$1" = "on" ]; then
        xrandr --output $EXTERNAL_DISPLAY --auto --left-of eDP1 --primary
        anker
        keyboard
        mouse
        echo "Docked"
    elif [ "$1" = "off" ]; then
        xrandr --output DP1 --off
        btc power off
        echo "Undocked"
    fi
}

#Better than netctl
wifi() {
    function list_profiles() {
       netctl list | cut --complement -d- -f1 | awk '{print NR-1 ") " $0}'
    }

    function get_current_ssid() {
        iw dev | grep ssid | awk '{print $2}'
    }

    dev=$(iw dev | grep Interface | awk '{print $2}')

    case $@ in
        #Connect by index (indices enumerated with wifi -l)
        *"-ci"*)
            index=$(echo "$2 + 1" | bc -l)
            to_connect=$(list_profiles | sed -n "$index p" | cut --complement -d" " -f1)
            echo "Attempting to connect to $to_connect..."
            current_ssid=`get_current_ssid`
            sudo netctl stop "$dev-$current_ssid"
            sudo netctl start "$dev-$to_connect"
            ;;
        #Connect by ssid name
        *"-c"*)
            echo "Attempting to connect to $2..."
            current_ssid=`get_current_ssid`
            sudo netctl stop "$dev-$current_ssid"
            sudo netctl start "$dev-$2"
            ;;
        #Disconnect from current ssid
        *"-d"*)
            current_ssid=`get_current_ssid`
            echo "Attempting to disconnect from $current_ssid..."
            sudo netctl stop "$dev-$current_ssid"
            ;;
        #List ssids with indices
        *"-l"*)
            list_profiles
            ;;
    esac
}
