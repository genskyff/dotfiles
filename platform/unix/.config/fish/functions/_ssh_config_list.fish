function _ssh_config_list --description "List ssh configuration files"
    set ssh_dir $HOME/.ssh
    set ssh_config_path $ssh_dir/config
    set ssh_confd_dir $ssh_dir/conf.d
    set files
    test -f "$ssh_config_path"; and set -a files $ssh_config_path

    for file in $ssh_confd_dir/**
        test -f "$file"; and set -a files "$file"
    end

    for file in $files
        echo "$file"
    end
end
