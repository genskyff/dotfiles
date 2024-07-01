function da --description "Attach to container"
    _docker_check; or return 1
    set container_name (dp | fzf | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker attach $container_name
    end
end
