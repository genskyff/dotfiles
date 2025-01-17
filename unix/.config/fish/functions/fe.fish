#!/usr/bin/env fish

function fe --description "Edit fish configuration"
    set files $__fish_config_dir/config.fish $__fish_config_dir/conf.d/**/*.fish
    set nth (math (string split / -- $__fish_config_dir | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." --delimiter / --query "$argv" \
            --bind "start:toggle-preview" \
            --bind "enter:become(fish -c '$EDITOR {}')"
end
