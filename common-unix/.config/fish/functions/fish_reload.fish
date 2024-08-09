#!/usr/bin/env fish

function fish_reload --description "Reload fish configuration"
    set config_path $HOME/.config/fish
    set files $config_path/config.fish $config_path/conf.d/*.fish

    for file in $files
        . $file
    end
end
