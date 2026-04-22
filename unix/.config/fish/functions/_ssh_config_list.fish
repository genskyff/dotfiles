function _ssh_config_list --description "List ssh configuration files"
    if _cmd_check -q fd
        set fd fd
    else if _cmd_check -q fdfind
        set fd fdfind
    else
        _cmd_check fd
        return 1
    end

    set ssh_dir $HOME/.ssh
    set ssh_config_path $ssh_dir/config
    set ssh_confd_dir $ssh_dir/conf.d
    set files
    test -f "$ssh_config_path"; and set -a files $ssh_config_path
    test -d "$ssh_confd_dir"; and set -a files ($fd . "$ssh_confd_dir" -tf -L)

    for file in $files
        echo "$file"
    end
end
