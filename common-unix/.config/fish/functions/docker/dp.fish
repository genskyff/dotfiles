function dp --description "List containers with status"
    _docker_check; or return 1

    set result (docker ps --format "{{.Names}} {{.Status}}" $argv)
    if test $status -ne 0
        echo -n "$result"
        return 1
    end

    for container in $result
        echo $container | read -l container_name container_status
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
    if contains -- "-a" $argv; or contains -- "--all" $argv
        set message "Total: $total Running: $(count $running_containers) Exited: $(count $exited_containers)"
    else
        set message "Running: $(count $running_containers)"
    end
    set message_length (string length -- "$message")
    test $total -gt 0; and set separator (string repeat -n $message_length "-"); and echo $separator
    echo "$message"
end
