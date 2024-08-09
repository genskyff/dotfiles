status is-interactive; or return

zoxide init fish | source

set -gx EDITOR nvim
set -gx fish_greeting
set -gx fish_function_path $HOME/.config/fish/functions/*/ $fish_function_path
set -gx FZF_DEFAULT_OPTS "--ansi --height=40% --layout=reverse --info=inline --border \
    --preview '
        if test -f {}
            batcat --color=always {}
        else
            echo -e {}
        end'
    --preview-window=border-none"

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

alias gb="git branch"
alias gw="git switch"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph"
alias gp="git pull"
