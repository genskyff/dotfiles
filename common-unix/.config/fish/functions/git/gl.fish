#!/usr/bin/env fish

function gl --description "git log with fzf"
    _git_check; or return 1
    git log --oneline --date=short --color=always --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s" \
        | fzf --preview "git show --color=always {2}" --bind "enter:become(git checkout {2})"
end
