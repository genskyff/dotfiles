function drm --description "Remove container"
    _docker_check; or return 1
    set container_name (dp -a | fzf | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker rm -f $container_name
    end
end
