#!/usr/bin/env fish

function da --description "Attach to container"
    _docker_check; or return 1
    _container_list | fzf --with-nth -1 --query "$argv[1]" \
        --preview "docker ps -a --filter id={1} \
            --format \
'ID:      {{.ID}}
Image:   {{.Image}}
Command: {{.Command}}
Created: {{.CreatedAt}}
Status:  {{.Status}}
Ports:   {{.Ports}}
Name:    {{.Names}}'" \
        --bind "enter:become(docker attach {1})"
end
