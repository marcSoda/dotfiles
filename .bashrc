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

shopt -s histappend
export PROMPT_COMMAND="history -a;${PROMPT_COMMAND}"
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export DOTFILES=~/working/dotfiles
export EDITOR=vim
export LESSHISTFILE=-
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
export _JAVA_AWT_WM_NONREPARENTING=1 # issue  with weird java windows:
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GOPATH="$XDG_DATA_HOME"/go
export WINEPREFIX="$XDG_DATA_HOME"/wine

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$XDG_DATA_HOME/cargo/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

#aliases:
#system
alias c='clear'
alias sb='source ~/.bashrc'
alias hb='systemctl hibernate'
alias pacman='sudo pacman'
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S $1'
alias pacrm='sudo pacman -R $1'
alias peg='procs'
alias grep='grep --color=auto'
alias gerp='grep -rnI $1 $2 --color'
alias gerpi='grep -rnIi $1 $2 --color'
alias fnd='find $2 | grep $1 --color'
alias fndi='find $2 | grep -i $1 --color'
alias ls='exa -al --icons --git --no-user --no-time --no-filesize -s=type'
alias rm='rm -v'
alias top='gotop'
alias ks='xset r rate 180 60'
alias fehr='bash $DOTFILES/backgrounds/feh.sh &'
alias pg='ping 8.8.8.8'
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias duh='du -ah --max-depth=1 . | sort -rh'
alias vim='nvim'
alias xr='xmonad --recompile && xmonad --restart'
#nav
alias cw='cd ~/working'
alias cdev='cd ~/working/dev'
alias cdot='cd $DOTFILES'
alias ctem='cd ~/working/temp'
alias cdow='cd ~/working/downloads'
alias cmis='cd ~/working/misc'
alias corg='cd ~/working/org'
alias cnex='cd ~/working/nextcloud'
alias cen='cd ~/working/dev/osb/.envcfg.d'
# network
alias nmc='nmcli'
# protonvpn
alias wgup='sudo systemctl start wg-quick@wg-US-NY-250'
alias wgdown='sudo systemctl stop wg-quick@wg-US-NY-250'
alias wgs='sudo wg show'
#bluetooth
alias btc='bluetoothctl'
alias btui='bluetuith'
alias pods='btc power on && btc connect AC:90:85:61:CB:FC'
alias buds='btc power on && btc connect F4:7D:EF:4F:43:98'
alias anker='btc power on && btc connect 08:EB:ED:6E:E8:29'
alias keyboard='btc power on && btc connect DC:2C:26:F8:7F:DC'
alias mouse='btc power on && btc connect FA:BE:26:DE:58:8B'
alias jbl='btc power on && btc connect F8:DF:15:D8:2F:C3'
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
# docker
dca() {
  docker compose exec "$1" bash
}
# autocomplete for dca
_dca_complete() {
  export PROFILE="UNSET_BY_BASHRC" #hides warnings for solar containers
  local cur=${COMP_WORDS[COMP_CWORD]}
  local containers=$(docker compose ps --services)
  COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}
complete -F _dca_complete dca

# restart bluetoth and pipewire
br() {
    systemctl --user restart pipewire
    sudo systemctl stop bluetooth
    sudo systemctl start bluetooth
}

# win10 vm
win() {
    # running with -m 100 binds right-alt (keycode 100) to mouse capture and release
    start_lg() { looking-glass-client -m 100 > /dev/null 2>&1 & }
    case $1 in
        "up"|"u")
            # Start the Windows VM
            echo "Starting win10"
            sudo virsh start win10
            echo "Starting looking glass"
            start_lg
            ;;
        "down"|"d")
            echo "Shutting down win10"
            sudo virsh shutdown win10
            ;;
        "kill"|"k")
            echo "Killing win10"
            sudo virsh destroy win10
            ;;
        "attach"|"a")
            echo "Reattaching win10"
            start_lg
            ;;
        *)
            echo "Error: must be (u)p, (d)own, (k)ill, or (a)ttach"
            ;;
    esac
}

#change screen layout
lay() {
    bash $DOTFILES/screenlayout.bash $@
}

# zathura
za() {
    zathura $1 > /dev/null 2>&1 & disown
}

# only office
oo() {
    command onlyoffice-desktopeditors ./"$1" &>/dev/null & disown
}

#tmux
tm() {
    if [[ $# = 0 ]]; then
        /usr/bin/tmux
    elif [[ $1 = "a" ]]; then #attach
        /usr/bin/tmux new-session -t $2
    elif [[ $1 = "k" ]]; then #kill
        /usr/bin/tmux kill-session -t $2
    elif [[ $1 = "l" ]]; then #list
        /usr/bin/tmux list-sessions
    elif [[ $1 = "p" ]]; then #purge non-attached sessions created by -c
        tmux list-sessions | grep -v "(attached)" | cut -d: -f1 | while read s; do
            tmux kill-session -t $s
        done
    fi
}

tshare() {
    TSHARE_PATH="/home/marc/Nextcloud/tshare.txt"
    vim $TSHARE_PATH
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

#enable starship prompt
eval "$(starship init bash)"
