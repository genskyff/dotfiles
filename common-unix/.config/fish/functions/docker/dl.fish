function dl --description "Logs of container"
    _docker_check; or return 1
    set container_name (_container_list -a | fzf --exact | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker logs $container_name $argv
    end
end
