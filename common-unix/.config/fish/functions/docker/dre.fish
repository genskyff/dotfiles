#!/usr/bin/env fish

function dre --description "Restart container"
    _docker_check; or return 1
    _container_list -a \
        | fzf --with-nth "2.." --query "$argv" --multi \
            --preview "fish $HOME/.config/fish/functions/docker/fzf_preview.fish {1}" \
            --bind "ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle,enter:become(docker restart {2})"
end
