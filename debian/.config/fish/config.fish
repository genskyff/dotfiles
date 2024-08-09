#!/usr/bin/env fish

status is-interactive; or return

zoxide init fish | source

set -gx EDITOR nvim
set -gx fish_greeting
set -gx fish_function_path $HOME/.config/fish/functions/*/ $fish_function_path
set -gx FZF_DEFAULT_OPTS "--ansi --height 50% --layout reverse --info inline --border \
    --preview 'fish $HOME/.config/fish/functions/fzf_preview.fish {}' \
    --preview-window border-left,60%"

alias cls=clear
alias cat=batcat
alias fd=fdfind
alias ff=fastfetch

alias vi=nvim
alias vim=nvim

alias ls=lsd
alias ll="ls -l"
alias la="ls -A"
alias lla="ll -A"
alias lt="ls --tree --depth 1"
alias lp="ls --classic"
alias ltp="lp --tree --depth 1"

alias gs="git status"
alias gd="git diff"
alias gp="git pull"
