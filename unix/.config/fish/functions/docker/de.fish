function de --description "Execute command in container"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    _container_list | fzf --with-nth 2 \
        --preview "_docker_fzf_preview {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(docker exec -it {2} $argv)"
end
