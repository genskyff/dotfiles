function dp --description "List containers"
    _docker_check; or return 1
    docker ps --format "{{.Names}} {{.Status}}" $argv | while read -l container_name container_status
        if string match -qr "Exited*" $container_status
            set exited_containers $exited_containers "$container_name (Exited)"
        else if string match -qr "Up*" $container_status
            set running_containers $running_containers $container_name
        end
    end

    for container in $running_containers
        echo $container
    end

    for container in $exited_containers
        echo $container
    end

    set total (math (count $running_containers) + (count $exited_containers))
    if contains -- "-a" $argv; contains -- "--all" $argv
        set msg "Total: $total Running: $(count $running_containers) Exited: $(count $exited_containers)"
    else
        set msg "Running: $(count $running_containers)"
    end
    set msg_length (string length -- "$msg")
    test $total -gt 0; and set seps (string repeat -n $msg_length "-"); and echo $seps >&2
    echo "$msg" >&2
end
