#!/usr/bin/env fish

function gb --description "git branch with fzf"
    _git_check; or return 1

    set branches (git branch)
    set current_ref $(git rev-parse --abbrev-ref HEAD)
    set header
    if test $current_ref = "HEAD"
        set header --header $branches[1]
        set branches $branches[2..-1]
    end

    string join \n $branches \
        | fzf --preview "git log {-1} --oneline --graph --date="format:%y/%m/%d" --color=always \
                --format='%C(auto)%cd %h%d <%<(6,trunc)%an> %s'" \
            --bind "enter:become(git switch {-1})" $header
end
