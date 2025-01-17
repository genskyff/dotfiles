#!/usr/bin/env fish

function de --description "Execute command in container"
    _docker_check; or return 1
    _fzf_check; or return 1

    _container_list | fzf --with-nth 2 \
        --preview "fish $__fish_config_dir/functions/docker/_fzf_preview.fish {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(fish -c 'docker exec -it {2} $argv')"
end
