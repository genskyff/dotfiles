#!/usr/bin/env fish

function efc --description "Edit fish configuration"
    _fzf_check; or return 1

    set files $__fish_config_dir/config.fish $__fish_config_dir/conf.d/**/*.fish
    set nth (math (string split / -- $__fish_config_dir | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." --delimiter / --query "$argv" \
            --bind "start:toggle-preview" \
            --bind "enter:become(fish -c '$EDITOR {}')"
end
