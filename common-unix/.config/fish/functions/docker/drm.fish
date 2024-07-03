function drm --description "Remove container"
    _docker_check; or return 1
    set container_name (_container_list -a | fzf --exact --query="$argv[1]" -1 | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker rm -f $container_name
    end
end
