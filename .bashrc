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

export DOTFILES=~/working/dotfiles
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

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=""$XDG_DATA_HOME"/cargo/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"

export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"


#aliases:
#system
alias x='startx'
alias c='clear'
alias sb='source ~/.bashrc'
alias hb='systemctl hibernate'
alias pacman='sudo pacman'
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S $1'
alias pacrm='sudo pacman -R $1'
alias peg='procs'
alias grep='grep --color=auto'
alias gerp='grep -rnIi $1 $2 --color'
alias ls='exa -al --icons --git --no-user --no-time --no-filesize -s=type'
alias rm='rm -v'
alias top='gotop'
alias ks='xset r rate 220 40'
alias fehr='bash $DOTFILES/backgrounds/feh.sh &'
alias sc='wine "/home/marc/.wine/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"'
alias wr='sudo systemctl restart netctl-auto@wlan0.service'
alias pg='ping google.com'
alias wget='wget --no-hsts'
alias duh='du -ah --max-depth=1 . | sort -rh'

#taskwarrior
export TASKRC=$DOTFILES/task/taskrc
alias t='task $1'
alias ta='task add $1'
alias te='task edit $1'
alias tc='task mod $1'
alias td='task done $1'
alias tdel='task delete $1'
alias tdaily='function _tdaily() { task add recur:daily due:2:00 wait:5:00 "$*" +daily; }; _tdaily'
alias ts='task sync'

#bluetooth
alias btc='bluetoothctl'
alias pods='btc power on && btc connect AC:90:85:61:CB:FC'
alias buds='btc power on && btc connect F4:7D:EF:4F:43:98'
alias anker='btc power on && btc connect 08:EB:ED:6E:E8:29'
alias keyboard='btc power on && btc connect DC:2C:26:F8:7F:DC'
alias mouse='btc power on && btc connect FA:BE:26:DE:58:83'
alias jbl='btc power on && btc connect F8:DF:15:D8:2F:C3'

#sshfs | this is not used anymore, but I'm keeping it in here to serve as an example
alias fsh1='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 -o sshfs_sync -o compression=yes -o auto_cache -o cache=no -o umask=022 -o allow_other -o IdentityFile=/home/marc/.ssh/id_rsa -o ssh_command="ssh -F /home/marc/.ssh/config" sunlab:/home/masa20/working/475/h1 /mnt/remote/475h1'
alias fsh2='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 -o sshfs_sync -o compression=yes -o auto_cache -o cache=no -o umask=022 -o allow_other -o IdentityFile=/home/marc/.ssh/id_rsa -o ssh_command="ssh -F /home/marc/.ssh/config" sunlab:/home/masa20/working/475/h2 /mnt/remote/475h2'
alias fsh3='sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 -o sshfs_sync -o compression=yes -o auto_cache -o cache=no -o umask=022 -o allow_other -o IdentityFile=/home/marc/.ssh/id_rsa -o ssh_command="ssh -F /home/marc/.ssh/config" sunlab:/home/masa20/working/475/h3 /mnt/remote/475h3'
alias unfsh1='fusermount -u /mnt/remote/475h1'
alias unfsh2='fusermount -u /mnt/remote/475h2'
alias unfsh3='fusermount -u /mnt/remote/475h3'

#git
alias g='git status'
alias gs='git status -s'
alias gp='git push'
alias gst='git status'
alias ga='git add'
alias gd='git diff'
alias gck='git checkout'
alias gb='git branch'
alias gl='git log'
gc() {
    git commit -m "$*"
}

#nav
alias cw='cd ~/working'
alias cdev='cd ~/working/dev'
alias cleh='cd ~/working/dev/lehigh'
alias csol='cd ~/working/dev/solar'
alias cdot='cd $DOTFILES'
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
#tunnel from localhost:9090 to gateway gitlab.cse.lehigh.edu:80 because gitlab.cse.lehigh.edu can only be accessed via lehigh network
alias tun411='ssh -L 9090:gitlab.cse.lehigh.edu:80 -N -f gateway'

#network
alias lehigh='sudo netctl stop-all && sudo netctl start lehigh'
alias pierce='sudo netctl stop-all && sudo netctl start 618\ Pieeeeeeerce'
alias home='sudo netctl stop-all && sudo netctl start OldManDing'

#minecwaft
alias mine='prime-run minecraft-launcher & disown'


ftl() {
    cd /home/marc/.local/share/Steam/steamapps/common/FTL\ Faster\ Than\ Light
    ./FTL 2>&1>&0 > /dev/null & disown
    cd -
}

#emacs remote dev using named workspaces
alias eltanin='e e "/ssh:gateway|ssh:eltanin:working/"'
alias seed='e n "/ssh:gateway|ssh:seed:working/"'
alias das='e d /ssh:das:working/'
alias electron='e t /ssh:electron:working/'
alias ancilla='e a /ssh:ancilla:working/'
alias sunlab='e s "/ssh:gateway|ssh:sunlab:working"'

#emacsclient named workspaces | this isn't used anymore, but you may want to update it now that you use GUI emacs
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

za() {
    zathura $1 > /dev/null 2>&1 & disown
}

lo() {
    command libreoffice "$1" &>/dev/null & disown
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
	cd -
    else
        /usr/bin/pass "$@"
    fi
}

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

#enable starship prompt
eval "$(starship init bash)"
