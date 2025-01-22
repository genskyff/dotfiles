#!/usr/bin/env fish

function dl --description "Logs of container"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    _container_list -a | fzf --with-nth "2.." \
        --preview "fish $__fish_config_dir/functions/docker/_fzf_preview.fish {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(fish -c 'docker logs -f --since $(date +%Y-%m-%dT%H:%M:%S) {2}')"
end
