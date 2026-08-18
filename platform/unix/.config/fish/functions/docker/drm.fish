function drm --description "Remove container"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    _container_list -a |
        fzf --with-nth "2.." --multi \
            --preview "_docker_fzf_preview {1}" \
            --bind "start:toggle-preview" \
            --bind "ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle,enter:become(docker rm -f {+2})"
end
