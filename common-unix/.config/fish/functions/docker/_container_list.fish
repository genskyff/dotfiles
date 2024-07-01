function _container_list --description "List containers"
    _docker_check; or return 1

    docker ps --format "{{.Names}} {{.Status}}" $argv | while read -l container_name container_status
        if string match -qr "Exited*" $container_status
            set exited_containers $exited_containers "$container_name (Exited)"
        else if string match -qr "Up*" $container_status
            set running_containers $running_containers $container_name
        end
    end

    for container in $exited_containers
        echo $container
    end

    for container in $running_containers
        echo $container
    end
end
