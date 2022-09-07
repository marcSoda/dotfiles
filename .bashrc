#!/bin/bash

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

#Add ls colors
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features
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
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

#set editor
export EDITOR=vim

#set .lesshst location
export LESSHISTFILE=-

#error with weird java windows:
export _JAVA_AWT_WM_NONREPARENTING=1

#set external display NOTE: I don't think I use this anymore
export EXTERNAL_DISPLAY=DP1
export PROJECTOR_PORT=DP3

#aliases:

#system
alias x='startx'
alias c='clear'
alias hb='systemctl hibernate'
alias pacman='sudo pacman'
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S $1'
alias pacrm='sudo pacman -R $1'
alias peg='ps -aux | grep $1'
alias grep='grep --color=auto'
alias ls='exa -al --icons --git --no-user --no-time --no-filesize -s=type'
alias rm='rm -v'
alias htop='bpytop'
alias ks='xset r rate 220 40'
alias fehr='feh --no-fehbg --bg-scale "/home/marc/working/dotfiles/backgrounds/05.jpg"'
alias sc='wine "/home/marc/.wine/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"'
alias wr='sudo systemctl restart netctl-auto@wlan0.service'

#temporary
alias sqldev='ssh -L 1521:localhost:1521 -N -f edgar1 && bash /opt/sqldeveloper/sqldeveloper.sh & disown'



#bluetooth
alias btc='bluetoothctl'
alias pods='btc power on && btc connect AC:90:85:61:CB:FC'
alias buds='btc power on && btc connect F4:7D:EF:4F:43:98'
alias anker='btc power on && btc connect 08:EB:ED:6E:E8:29'
alias keyboard='btc power on && btc connect DC:2C:26:F8:7F:DC'
alias mouse='btc power on && btc connect FA:BE:26:DE:58:83'
alias jbl='btc power on && btc connect F8:DF:15:D8:2F:C3'
br() {
    killall -9 pulseaudio
    pulseaudio --start -v
    sudo systemctl stop bluetooth
    sudo systemctl start bluetooth
    btc power off
    btc power on
}

#c
alias mg='gcc -g -Wall -Wextra -Wwrite-strings'
alias mg+='g++ -g -Wall -Wextra -Wwrite-strings'

#lehigh vpn
alias lvpn='/opt/cisco/anyconnect/bin/vpnui'

#network
alias lehigh='sudo netctl stop-all && sudo netctl start lehigh'
alias pierce='sudo netctl stop-all && sudo netctl start 618\ Pieeeeeeerce'
alias home='sudo netctl stop-all && sudo netctl start OldManDing'

#minecwaft
alias mine='prime-run minecraft-launcher & disown'

#emacs remote dev using named workspaces
alias eltanin='e e "/ssh:gateway|ssh:eltanin:working/"'
alias seed='e n "/ssh:gateway|ssh:seed:working/"'
alias das='e d /ssh:das:working/'
alias electron='e t /ssh:electron:working/'
alias ancilla='e a /ssh:ancilla:working/'
alias sunlab='e s "/ssh:gateway|ssh:sunlab:working"'


#emacsclient named workspaces
e() {
    if [[ $1 = "-k" ]]; then
        /usr/bin/emacsclient -s $2 -e '(kill-emacs)'
        return
    elif [[ ${#1} = 1 ]]; then
       name=$1
       file=$2
    else
       name=0
       file=$1
    fi
    /usr/bin/emacsclient -s $name -nw $file
    ret=$?
    if [[ $ret != 0 ]] && [[ $ret != 147 ]] ; then
        /usr/bin/emacs --daemon=$name
        /usr/bin/emacsclient -s $name $file
    fi
}

#change screen layout
lay() {
    bash ~/.screenlayout/$1.bash
}

#zathura
za() {
    zathura $1 & disown
}

#tmux
tm() {
    if [[ $# = 0 ]]; then
        /usr/bin/tmux -f /home/marc/working/dotfiles/.tmux.conf
    elif [[ $1 = "-a" ]]; then
        /usr/bin/tmux attach-session -t $2
    elif [[ $1 = "-k" ]]; then
        /usr/bin/tmux kill-session -t $2
    elif [[ $1 = "-l" ]]; then
        /usr/bin/tmux list-sessions
    fi
}

#share text to dropbox
tshare() {
    echo "${@:1}" > ~/working/misc/tshare.txt
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
