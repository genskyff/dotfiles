#!/usr/bin/env fish

status is-interactive; or return 0

set -gx fish_greeting
set fish_function_path (realpath $HOME/.config/fish/functions/**/) $fish_function_path
set fish_function_path (string join \n $fish_function_path | awk '!seen[$0]++')

alias cls=clear
alias ff=fastfetch
alias bt="btm -b"
alias vim=nvim
alias cat=batcat
alias fd=fdfind

alias ls="lsd -N"
alias ll="ls -l"
alias la="ls -A"
alias lla="ll -A"
alias lt="ls --tree --depth 1"
alias lp="ls --classic"
alias ltp="lp --tree --depth 1"

alias gs="git status"
alias gw="git switch"
alias gd="git diff"
alias gp="git pull"
alias gss="git submodule status"
alias gsu="git submodule update"
