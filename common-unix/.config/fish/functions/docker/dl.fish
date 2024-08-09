#!/usr/bin/env fish

function dl --description "Logs of container"
    _docker_check; or return 1
    set container_name (_container_list -a | fzf --query="$argv[1]" -1 | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker logs -f --since "$(date +%Y-%m-%dT%H:%M:%S)" $container_name
    end
end
