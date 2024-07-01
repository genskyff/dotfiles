function dl --description "Logs of container"
    _docker_check; or return 1
    set container_name (dp -a | fzf | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker logs $container_name $argv
    end
end
