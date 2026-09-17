function gb --description "git branch with fzf"
    _git_check; or return 1
    _cmd_check fzf; or return 1

    set -l branches (git branch)
    set -l current_ref $(git rev-parse --abbrev-ref HEAD)
    set -l header
    if test "$current_ref" = HEAD
        set header --header $branches[1]
        set branches $branches[2..-1]
    end

    string join \n $branches \
        | fzf --preview 'git log {-1} --oneline --graph --color=always --date="format:%y/%m/%d" --format="%C(auto)%ad %h%d <%<(6,trunc)%an> %s"' \
        --bind "start:toggle-preview" \
        --bind "enter:become(git switch {-1})" $header
end
