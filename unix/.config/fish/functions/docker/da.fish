#!/usr/bin/env fish

function da --description "Attach to container"
    _docker_check; or return 1
    _fzf_check; or return 1

    _container_list | fzf --with-nth 2 --query "$argv" \
        --preview "fish $__fish_config_dir/functions/docker/_fzf_preview.fish {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(fish -c 'docker attach {2}')"
end
