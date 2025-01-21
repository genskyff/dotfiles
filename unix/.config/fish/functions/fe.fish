#!/usr/bin/env fish

function fe --description "Edit fish configuration"
    _cmd_check --fn fd; or return 1
    _cmd_check fzf; or return 1

    set fish_config_path $__fish_config_dir/config.fish
    set fish_confd_path $__fish_config_dir/conf.d
    test -f $fish_config_path; and set files $fish_config_path; or set files
    test -d $fish_confd_path; and set -a files (fd . $fish_confd_path -tf -L)
    set nth (math (string split / -- $__fish_config_dir | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." --delimiter / --query "$argv" \
            --bind "start:toggle-preview" \
            --bind "enter:become(fish -c '$EDITOR {}')"
end
