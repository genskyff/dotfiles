alias cls=clear

command -q batcat; and alias cat=batcat; or alias cat=bat
command -q btm; and alias bt="btm -b"
command -q fastfetch; and alias ff=fastfetch
command -q fdfind; and alias fd=fdfind
command -q helix; and alias hx=helix
command -q kitten; and set -q KITTY_PID; and alias s="kitten ssh"
command -q lazydocker; and alias lad=lazydocker
command -q lazygit; and alias lg=lazygit
command -q nvim; and alias vim=nvim
command -q onefetch; and alias of=onefetch
command -q zellij; and alias zj=zellij

command -q lsd; and begin
    alias ls="lsd -N"
    alias ll="ls -l"
    alias la="ls -A"
    alias lla="ll -A"
    alias lt="ls --tree --depth 1"
    alias lp="ls --classic"
    alias ltp="lp --tree --depth 1"
end

command -q git; and begin
    alias gs="git status"
    alias gw="git switch"
    alias gd="git diff"
    alias gp="git pull"
    alias gss="git submodule status"
    alias gsu="git submodule update"
end
