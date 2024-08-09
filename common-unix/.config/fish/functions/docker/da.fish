function da --description "Attach to container"
    _docker_check; or return 1
    set container_name (_container_list | fzf --query="$argv[1]" -1 | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker attach $container_name
    end
end
