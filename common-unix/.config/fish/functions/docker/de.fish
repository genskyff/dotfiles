function de --description "Execute command in container"
    _docker_check; or return 1
    set container_name (_container_list | fzf --ansi --exact | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker exec -it $container_name $argv
    end
end
