#!/usr/bin/env fish

function dre --description "Restart container"
    _docker_check; or return 1
    _fzf_check; or return 1

    _container_list -a |
        fzf --with-nth "2.." --query "$argv" --multi \
            --preview "fish $__fish_config_dir/functions/docker/_fzf_preview.fish {1}" \
            --bind "start:toggle-preview" \
            --bind "ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle,enter:become(fish -c 'docker restart {+2}')"
end
