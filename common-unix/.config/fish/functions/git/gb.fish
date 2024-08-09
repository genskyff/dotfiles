#!/usr/bin/env fish

function gb --description "git branch with fzf"
    _git_check; or return 1
    git branch \
        | fzf --preview "git log {-1} --oneline --graph --date=short --color=always \
                --format='%C(auto)%cd %h%d <%<(6,trunc)%an> %s'" \
            --bind "enter:become(git checkout {-1})"
end
