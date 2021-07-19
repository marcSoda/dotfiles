#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

#add to path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
#init .xinitrc
startx
