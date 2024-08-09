#!/usr/bin/env fish

function de --description "Execute command in container"
    _docker_check; or return 1
    _container_list | fzf --with-nth -1 \
        --preview 'fish $HOME/.config/fish/functions/docker/fzf_preview.fish {1}' \
        --bind "enter:become(docker exec -it {1} $argv)"
end
