function fe --description "Edit fish configuration"
    _cmd_check fzf; or return 1

    set -l fish_config_path $__fish_config_dir/config.fish
    test -f $fish_config_path; and set -l files $fish_config_path; or set -l files
    set -a files $__fish_config_dir/conf.d/**/*.fish
    set -l nth (math (string split / "$__fish_config_dir" | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." -d/ \
        --bind "start:toggle-preview" \
        --bind "enter:become($EDITOR {})"
end
