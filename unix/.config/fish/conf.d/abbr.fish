status is-interactive; or return 0

abbr -a cls clear

command -q batcat; and abbr -a bat batcat
command -q btm; and abbr bt btm -b
command -q choose; and abbr -a cho choose
command -q fastfetch; and abbr -a ff fastfetch
command -q fdfind; and abbr -a fd fdfind
command -q helix; and abbr -a hx helix
command -q lazydocker; and abbr -a lad lazydocker
command -q lazygit; and abbr -a lg lazygit
command -q zellij; and abbr -a zj zellij

command -q lsd; and begin
    abbr -a ls lsd -N
    abbr -a ll lsd -Nl
    abbr -a la lsd -NA
    abbr -a lla lsd -NlA
    abbr -a lt lsd -N --tree --depth 1
    abbr -a lp lsd -N --classic
    abbr -a ltp lsd -N --classic --tree --depth 1
end

command -q git; and begin
    abbr -a gd git diff -w
    abbr -a gp git pull
    abbr -a gs git status
    abbr -a gw git switch

    abbr -a gss git submodule status
    abbr -a gsu git submodule update

    command -q difft; and abbr -a gdt git -c diff.external=difft diff
end
