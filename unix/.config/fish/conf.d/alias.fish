status is-interactive; or return 0

abbr -a cls clear

command -q batcat; and abbr -a bat batcat
command -q btm; and abbr bt btm -b
command -q choose; and abbr -a cho choose
command -q fastfetch; and abbr -a ff fastfetch
command -q fdfind; and abbr -a fd fdfind
command -q helix; and abbr -a hx helix
command -q kitten; and set -q KITTY_PID; and abbr -a s kitten ssh
command -q lazydocker; and abbr -a lad lazydocker
command -q lazygit; and abbr -a lg lazygit
command -q nvim; and abbr -a nv nvim
command -q onefetch; and abbr -a of onefetch
command -q zellij; and abbr -a zj zellij

command -q lsd; and begin
    abbr -a ls lsd -N
    abbr -a ll ls -l
    abbr -a la ls -A
    abbr -a lla ll -A
    abbr -a lt ls --tree --depth 1
    abbr -a lp ls --classic
    abbr -a ltp lp --tree --depth 1
end

command -q git; and begin
    abbr -a gs git status
    abbr -a gw git switch
    abbr -a gd git diff -w
    abbr -a gp git pull
    abbr -a gss git submodule status
    abbr -a gsu git submodule update
end
