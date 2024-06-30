function dre --description "Restart container"
    set container_name (dp -a | fzf | awk '{print $1}')
    if string length -- $container_name &>/dev/null
        sudo docker restart $container_name
    end
end
