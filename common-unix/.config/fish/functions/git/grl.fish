#!/usr/bin/env fish

function grl --description "git reflog with fzf"
    _git_check; or return 1
    git reflog --color=always --date="format:%m/%d %H:%M" --format="%C(auto)%cd %h%d %gs" \
        | fzf --preview "git show --color=always {3}" \
            --bind "enter:become(git checkout {3})"
end
