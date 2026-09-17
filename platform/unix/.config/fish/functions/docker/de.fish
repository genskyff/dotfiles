function de --description "Execute command in container"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    set -l target (_container_list | fzf --with-nth 2 \
        --preview "_docker_fzf_preview {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(echo {2})"); or return 1

    docker exec -it "$target" $argv
end
