#!/usr/bin/env fish

function da --description "Attach to container"
    _docker_check; or return 1
    _container_list | fzf --with-nth -1 --query "$argv" \
        --preview "fish $HOME/.config/fish/functions/docker/fzf_preview.fish {1}" \
        --bind "enter:become(docker attach {1})"
end
