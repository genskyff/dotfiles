function se --description "Edit ssh configuration"
    _cmd_check fzf; or return 1

    set list (_ssh_config_list)
    set ssh_path $HOME/.ssh
    set nth (math (string split / $ssh_path | count) + 1)
    string join \n $list \
        | fzf --with-nth "$nth.." -d/ \
        --preview-window hidden \
        --bind "enter:become($EDITOR {})"
end
