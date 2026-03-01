function se --description "Edit ssh configuration"
    _cmd_check fzf; or return 1

    set files (_ssh_config_list)
    set ssh_dir $HOME/.ssh
    set nth (math (string split / "$ssh_dir" | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." -d/ \
        --preview-window hidden \
        --bind "enter:become($EDITOR {})"
end
