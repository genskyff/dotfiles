#!/usr/bin/env fish

status is-interactive; or return

fzf --fish | source
zoxide init fish | source

set -gx EDITOR nvim
set -gx fish_greeting

set exclude ""
test (uname) = "Darwin"
and set exclude "-E Applications -E Library"
set -gx FZF_CTRL_T_COMMAND "fdfind -tf -td -tl -L --color always $exclude"
set -gx FZF_ALT_C_COMMAND "fdfind -td -L --color always $exclude"
set -gx FZF_DEFAULT_COMMAND "fdfind -tf -td -tl -L --color always $exclude"
set -gx FZF_DEFAULT_OPTS "--ansi --height 60% --highlight-line --reverse --info inline --border --no-separator \
    --preview 'fish $HOME/.config/fish/functions/_fzf_preview.fish {}' \
    --preview-window 'hidden,border-left,60%' \
    --bind 'alt-/:change-preview-window(90%|60%)' \
    --bind 'alt-,:toggle-wrap' \
    --bind 'alt-.:toggle-preview-wrap' \
    --bind 'ctrl-/:toggle-preview' \
    --bind 'alt-f:preview-page-down,alt-b:preview-page-up'"

set fish_function_path (path resolve $HOME/.config/fish/functions/**/) $fish_function_path
set fish_function_path (string join \n $fish_function_path | awk '!seen[$0]++')

alias cls=clear
alias cat=batcat
alias fd=fdfind
alias ff=fastfetch

alias vi=nvim
alias vim=nvim

alias ls="lsd -N"
alias ll="ls -l"
alias la="ls -A"
alias lla="ll -A"
alias lt="ls --tree --depth 1"
alias lp="ls --classic"
alias ltp="lp --tree --depth 1"

alias gs="git status"
alias gd="git diff"
alias gp="git pull"
alias gsu="git submodule update"
