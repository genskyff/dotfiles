#!/usr/bin/env fish

function drm --description "Remove container"
    _docker_check; or return 1
    set container_name (_container_list -a \
        | fzf --query="$argv[1]" -1 --multi --bind 'ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle' \
        | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker rm -f $container_name
    end
end
