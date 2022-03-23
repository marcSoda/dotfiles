### start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx
    end
end
###end
#vim-mode
fish_vi_key_bindings
###env
set -U fish_user_paths $fish_userr_paths $HOME/.local/bin/
set fish_greeting                                           #suppres fish intro message
set TERM "xterm-256color"
set EDITOR "emacsclient -t -a '' -s 0"
set VISUAL "emacsclient -c -a emacs -s 0"
set LESSHISTFILE -
set EXTERNAL_DISPLAY DP1
set PROJECTOR_PORT DP3
###end env
###aliases:
#system
alias c='clear'
alias pacman='sudo pacman'
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S $argv[1]'
alias pacrm='sudo pacman -R $argv[1]'
alias grep='grep --color=auto'
alias ls='exa -al --icons --git --no-user --no-time --no-filesize -s=type'
alias rm='rm -v'
alias ks='xset r rate 220 40'
alias fehr='feh --no-fehbg --bg-scale "/home/marc/working/dotfiles/backgrounds/05.jpg"'
#bluetooth
alias btc='bluetoothctl'
alias pods='btc power on && btc connect AC:90:85:61:CB:FC'
alias buds='btc power on && btc connect F4:7D:EF:4F:43:98'
alias anker='btc power on && btc connect 08:EB:ED:6E:E8:29'
alias keyboard='btc power on && btc connect DC:2C:26:F8:7F:DC'
alias mouse='btc power on && btc connect FA:BE:26:DE:58:83'
function br
    btc power off
    killall -9 pulseaudio
    pulseaudio --start
    btc power on
end
#c
alias mg='gcc -g -Wall -Wextra -Wwrite-strings'
alias mg+='g++ -g -Wall -Wextra -Wwrite-strings'
#lehigh vpn
alias lvpn='/opt/cisco/anyconnect/bin/vpnui'
#network
alias lehigh='sudo netctl stop-all && sudo netctl start lehigh'
alias pierce='sudo netctl stop-all && sudo netctl start 618\ Pieeeeeeerce'
alias home='sudo netctl stop-all && sudo netctl start OldManDing'
#emacs remote dev using named workspaces
alias eltanin='e e "/ssh:gateway|ssh:eltanin:working/"'
alias seed='e n "/ssh:gateway|ssh:seed:working/"'
alias das='e d /ssh:das:working/'
alias ancilla='e a /ssh:ancilla:working/'
alias sunlab='e s "/ssh:gateway|ssh:sunlab:working"'
###end aliases

###emacsclient named workspaces
function e
    if set -q argv[1] && test $argv[1] = "-k"
        /usr/bin/emacsclient -s $argv[2] -e '(kill-emacs)'
        return
    else if set -q argv[1] && test (string length $argv[1]) -eq 1
        set name $argv[1]
        set file $argv[2]
    else
        set name 0
        set file $argv[1]
    end
    /usr/bin/emacsclient -nw -s $name $file
    if test $status -ne 0 -a $status -ne 147
        echo $name
        /usr/bin/emacs --daemon=$name -nw
        /usr/bin/emacsclient -nw -s $name $file
    end
end
### end emacsclient

#change screen layout
function lay
    bash ~/.screenlayout/$argv[1].sh
end

#zathura
function za
    zathura $argv[1] & disown
end

#tmux
function tm
    if test (count $argv) -eq 0
        /usr/bin/tmux -f /home/marc/working/dotfiles/.tmux.conf
    else if test $argv[1] = "-a"
        /usr/bin/tmux attach-session -t $argv[2]
    else if test $argv[1] = "-k"
        /usr/bin/tmux kill-session -t $argv[2]
    else if test $argv[1] = "-l"
        /usr/bin/tmux list-sessions
    end
end

# share text to dropbox
function tshare
    echo $argv > ~/working/misc/tshare.txt
end

#Custom pass behavior
function pass
    if test $argv[1] = "sync"
        cd ~/.password-store
        git pull --rebase  && git push
    else
        /usr/bin/pass $argv
    end
end

### bang-bang (!!) functionality from bash
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end
function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end
bind ! __history_previous_command
bind '$' __history_previous_command_arguments
if test "$fish_key_bindings" = 'fish_vi_key_bindings'
    bind --mode insert ! __history_previous_command
    bind --mode insert '$' __history_previous_command_arguments
end
### --end bang-bang--

###PROMPT
function fish_prompt --description 'Write out the prompt'
    set fish_prompt_pwd_dir_length 0
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status --background=red white
    set -l color_cwd $fish_color_cwd
    set -l suffix '$'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    echo -n -s (prompt_login)':' (set_color blue) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
end
###end prompt