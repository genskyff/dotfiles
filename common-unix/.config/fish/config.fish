status is-interactive; or return

fzf --fish | source
starship init fish | source
zoxide init fish | source

set -gx EDITOR nvim

alias cat=bat
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

alias gb="git branch"
alias gw="git switch"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph"
alias gp="git pull"
