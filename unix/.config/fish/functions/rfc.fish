#!/usr/bin/env fish

function rfc --description "Reload fish configuration"
    set files $__fish_config_dir/config.fish $__fish_config_dir/conf.d/**/*.fish

    for file in $files
        . $file
    end
end
