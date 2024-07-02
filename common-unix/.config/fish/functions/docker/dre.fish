function dre --description "Restart container"
    _docker_check; or return 1
    set container_name (_container_list -a | fzf --exact | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker restart $container_name
    end
end
