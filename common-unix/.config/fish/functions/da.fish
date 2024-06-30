function da --description "Attach to container"
    set container_name (dp | fzf | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        sudo docker attach $container_name
    end
end
