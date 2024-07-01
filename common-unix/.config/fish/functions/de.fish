function de --description "Execute command in container"
    set container_name (dp | fzf | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        docker exec -it $container_name $argv
    end
end
