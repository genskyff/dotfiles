#!/usr/bin/env fish

function fe --description "Edit fish configuration"
    set config_path $HOME/.config/fish
    set files $config_path/config.fish $config_path/conf.d/**/*.fish
    set nth (math (string split / -- $config_path | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." --delimiter / --query "$argv" \
            --bind "start:toggle-preview" \
            --bind "enter:become(fish -c '$EDITOR {}')"
end
