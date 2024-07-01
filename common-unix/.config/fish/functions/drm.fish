function drm --description "Remove container"
    set container_name (dp -a | fzf | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker rm -f $container_name
    end
end
