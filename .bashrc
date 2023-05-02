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

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export EDITOR=vim
export LESSHISTFILE=-
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export _JAVA_AWT_WM_NONREPARENTING=1 # issue  with weird java windows:
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GOPATH="$XDG_DATA_HOME"/go
export WINEPREFIX="$XDG_DATA_HOME"/wine


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
alias top='gotop'
alias ks='xset r rate 220 40'
alias fehr='feh --no-fehbg --bg-scale "/home/marc/working/dotfiles/backgrounds/05.jpg"'
alias sc='wine "/home/marc/.wine/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"'
alias ftb='prime-run /home/marc/FTBA/FTBApp > /dev/null & disown'
alias wr='sudo systemctl restart netctl-auto@wlan0.service'
alias pg='ping google.com'
alias wget='wget --no-hsts'

#taskwarrior
alias t='task $1'
alias ta='task add $1'
alias te='task edit $1'
alias tc='task mod $1'
alias td='task done $1'

#bluetooth
alias btc='bluetoothctl'
alias pods='btc power on && btc connect AC:90:85:61:CB:FC'
alias buds='btc power on && btc connect F4:7D:EF:4F:43:98'
alias anker='btc power on && btc connect 08:EB:ED:6E:E8:29'
alias keyboard='btc power on && btc connect DC:2C:26:F8:7F:DC'
alias mouse='btc power on && btc connect FA:BE:26:DE:58:83'
alias jbl='btc power on && btc connect F8:DF:15:D8:2F:C3'

#sshfs
alias fsh1='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 -o sshfs_sync -o compression=yes -o auto_cache -o cache=no -o umask=022 -o allow_other -o IdentityFile=/home/marc/.ssh/id_rsa -o ssh_command="ssh -F /home/marc/.ssh/config" sunlab:/home/masa20/working/475/h1 /mnt/remote/475h1'
alias fsh2='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 -o sshfs_sync -o compression=yes -o auto_cache -o cache=no -o umask=022 -o allow_other -o IdentityFile=/home/marc/.ssh/id_rsa -o ssh_command="ssh -F /home/marc/.ssh/config" sunlab:/home/masa20/working/475/h2 /mnt/remote/475h2'
alias fsh3='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 -o sshfs_sync -o compression=yes -o auto_cache -o cache=no -o umask=022 -o allow_other -o IdentityFile=/home/marc/.ssh/id_rsa -o ssh_command="ssh -F /home/marc/.ssh/config" sunlab:/home/masa20/working/475/h3 /mnt/remote/475h3'
alias unfsh1='fusermount -u /mnt/remote/475h1'
alias unfsh2='fusermount -u /mnt/remote/475h2'
alias unfsh3='fusermount -u /mnt/remote/475h3'

#git
alias gs='git status -s'
alias ga='git add'
alias gd='git diff'
alias gc='git commit -m "$*"'
alias gck='git checkout'
alias gb='git branch'
alias gl='git log'

#nav
alias cleh='cd ~/working/dev/lehigh'
alias cdev='cd ~/working/dev'
alias cdot='cd ~/working/dotfile'
alias ctem='cd ~/working/temp'
alias cdow='cd ~/working/downloads'
alias cmis='cd ~/working/misc'

br() {
    killall -9 pulseaudio
    pulseaudio --start -v
    sudo systemctl stop bluetooth
    sudo systemctl start bluetooth
    btc power off
    btc power on
}

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

##sioyek
#sio() {
#    sioyek --new-window $1 > /dev/null 2>&1 & disown
#}
za() {
    zathura $1 > /dev/null 2>&1 & disown
}

#tmux
tm() {
    if [[ $# = 0 ]]; then
        /usr/bin/tmux
    elif [[ $1 = "-a" ]]; then #attach
        /usr/bin/tmux attach-session -t $2
    elif [[ $1 = "-k" ]]; then #kill
        /usr/bin/tmux kill-session -t $2
    elif [[ $1 = "-l" ]]; then #list
        /usr/bin/tmux list-sessions
    elif [[ $1 = "-c" ]]; then #connect to a session (windows share exact same properties, but NOT physical state)
        /usr/bin/tmux new-session -t $2
    elif [[ $1 = "-p" ]]; then #purge non-attached sessions created by -c
        tmux list-sessions | grep -v "(attached)" | cut -d: -f1 | while read s; do
            tmux kill-session -t $s
        done
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

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

#enable starship prompt
eval "$(starship init bash)"
