#!/usr/bin/env fish

function dcp --description "Copy files from container to host"
    _docker_check; or return 1
    test (count $argv) = 1; and set argv[2] (pwd)
    _container_list | fzf --with-nth 2 \
        --preview "fish $HOME/.config/fish/functions/docker/_fzf_preview.fish {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(fish -c 'docker cp --follow-link {2}:$argv[1] $argv[2]')"
end
