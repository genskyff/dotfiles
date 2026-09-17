function s --description "SSH with fzf"
    _cmd_check fzf ssh; or return 1

    set -l files (_ssh_config_list)
    set -l content (test -n "$files"; and cat $files)
    set -l host (string join \n $content | grep -E '^\s*Host\s+\S+' | grep -v "*" | awk '{print $2}' | fzf --preview-window hidden)
    or return 1

    if command -q kitten; and set -q KITTY_PID; and string match -q xterm-kitty "$TERM"
        kitten ssh "$host" $argv
    else
        ssh "$host" $argv
    end
end
