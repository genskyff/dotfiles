function se --description "Edit ssh configuration"
    _cmd_check fzf; or return 1

    set -l files (_ssh_config_list)
    set -l ssh_dir $HOME/.ssh
    set -l nth (math (string split / "$ssh_dir" | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." -d/ \
        --preview-window hidden \
        --bind "enter:become($EDITOR {})"
end
