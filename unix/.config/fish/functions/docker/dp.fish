function dp --description "List containers with fzf"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    set all_containers (_container_list -a)
    set total_count (count $all_containers)
    set exited_count (string match -r "Exited" $all_containers | count)
    set running_count (math $total_count - $exited_count)

    set message "$(set_color blue)Total: $total_count $(set_color green)Running: $running_count $(set_color red)Exited: $exited_count$(set_color normal)"

    string join \n $all_containers \
        | fzf --with-nth "2.." \
        --preview "_docker_fzf_preview {1}" \
        --header "$message" \
        --bind "start:toggle-preview"
end
