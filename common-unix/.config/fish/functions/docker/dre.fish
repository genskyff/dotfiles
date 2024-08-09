#!/usr/bin/env fish

function dre --description "Restart container"
    _docker_check; or return 1
    set container_name (_container_list -a \
        | fzf --query="$argv[1]" -1 --multi --bind 'ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle' \
        | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker restart $container_name
    end
end
