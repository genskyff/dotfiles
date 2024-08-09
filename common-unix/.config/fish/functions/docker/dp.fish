#!/usr/bin/env fish

function dp --description "List containers with status"
    _docker_check; or return 1

    docker ps -a --format "{{.ID}} {{.Names}} {{.Status}}" | while read -l container_id container_name container_status
        if string match -qr "Exited*" $container_status
            set exited_containers $exited_containers "$(set_color red)$container_id $container_name (Exited)$(set_color normal)"
        else if string match -qr "Up*" $container_status
            set running_containers $running_containers "$(set_color green)$container_id $container_name$(set_color normal)"
        end
    end

    set all_containers $exited_containers $running_containers
    set total (count $all_containers)
    set message_ori "Total: $total Running: $(count $running_containers) Exited: $(count $exited_containers)"
    set message "$(set_color blue)Total: $total $(set_color green)Running: $(count $running_containers) $(set_color red)Exited: $(count $exited_containers)$(set_color normal)"
    set message_length (string length -- "$message_ori")

    string join \n $all_containers \
        | fzf --with-nth "2.." \
            --preview "fish $HOME/.config/fish/functions/docker/fzf_preview.fish {1}" \
            --header "$message"
end
