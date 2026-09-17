function fr --description "Reload fish configuration"
    set -l files $__fish_config_dir/config.fish $__fish_config_dir/conf.d/**/*.fish

    for file in $files
        source "$file"
    end
end
