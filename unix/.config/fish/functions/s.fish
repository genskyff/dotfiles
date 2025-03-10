function s --description "SSH with fzf"
    _cmd_check fzf; or return 1

    set list (_ssh_config_list)
    set result (test -n "$list"; and cat $list)
    set host (string join \n $result | grep "^\s*Host " | grep -v "*" | cut -d' ' -f2 | fzf --preview-window hidden)
    test -n "$host"; or return 1

    if command -q kitten; and set -q KITTY_PID
        kitten ssh $host $argv
    else
        ssh $host $argv
    end
end
