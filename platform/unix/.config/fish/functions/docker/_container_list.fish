function _container_list --description "List containers"
    _docker_check; or return 1
    argparse -i header -- $argv; or return 1

    set -l exited_containers
    set -l running_containers
    set -l other_containers
    docker ps --format "{{.ID}} {{.Names}} {{.State}}" $argv | while read -l container_id container_name container_state
        if test "$container_state" = exited
            set -a exited_containers "$(set_color red)$container_id $container_name$(set_color normal)"
        else if test "$container_state" = running
            set -a running_containers "$(set_color green)$container_id $container_name$(set_color normal)"
        else
            set -a other_containers "$(set_color yellow)$container_id $container_name$(set_color normal)"
        end
    end

    set -l all_containers $exited_containers $other_containers $running_containers
    if set -q _flag_header
        echo "$(set_color green)Running: $(count $running_containers) $(set_color red)Exited: $(count $exited_containers) $(set_color yellow)Other: $(count $other_containers)$(set_color normal)"
    end

    for container in $all_containers
        echo "$container"
    end
end
