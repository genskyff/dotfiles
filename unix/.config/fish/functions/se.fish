#!/usr/bin/env fish

function se --description "Edit ssh configuration"
    _cmd_check fd fzf; or return 1

    set ssh_path $HOME/.ssh
    set ssh_config_path $ssh_path/config
    set ssh_confd_path $ssh_path/conf.d
    test -f $ssh_config_path; and set files $ssh_config_path; or set files
    test -d $ssh_confd_path; and set -a files (fd . $ssh_confd_path -tf -L)
    set nth (math (string split / -- $ssh_path | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." --delimiter / --query "$argv" \
            --bind "start:toggle-preview" \
            --bind "enter:become(fish -c '$EDITOR {}')"
end
