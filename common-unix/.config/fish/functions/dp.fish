function dp --description "List containers"
    if not command -q docker; or command -v docker | string match -qr "^/mnt"
        echo "$(set_color red)Error$(set_color normal): `docker` command not found" >&2
        return 1
    end

    set error_msg (command sudo docker version 2>&1 1>/dev/null)
    test (string length -- "$error_msg") -gt 0
    and echo "$(set_color red)Error$(set_color normal): $error_msg" >&2
    and return 1

    sudo docker ps --format "{{.Names}} {{.Status}}" $argv | while read -l container_name container_status
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
