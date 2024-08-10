#!/usr/bin/env fish

function fr --description "Reload fish configuration"
    set config_path $HOME/.config/fish
    set files $config_path/config.fish $config_path/conf.d/*.fish

    for file in $files
        . $file
    end
end
