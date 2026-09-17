function dp --description "List containers with fzf"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    set -l output (_container_list --header -a)

    string join \n $output[2..-1] \
        | fzf --with-nth "2.." \
        --preview "_docker_fzf_preview {1}" \
        --header "$output[1]" \
        --bind "start:toggle-preview"
end
