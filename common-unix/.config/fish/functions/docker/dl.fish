#!/usr/bin/env fish

function dl --description "Logs of container"
    _docker_check; or return 1
    _container_list -a | fzf --with-nth "2.." --query "$argv" \
        --preview "fish $HOME/.config/fish/functions/docker/fzf_preview.fish {1}" \
        --bind "enter:become(docker logs -f --since '$(date +%Y-%m-%dT%H:%M:%S)' {2})"
end
