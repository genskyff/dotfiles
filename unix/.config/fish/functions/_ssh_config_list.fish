function _ssh_config_list --description "List ssh configuration files"
    if _cmd_check -q fd
        set fd fd
    else if _cmd_check -q fdfind
        set fd fdfind
    else
        echo -e "$(set_color red)Error$(set_color normal): 'fd' command not found" >&2
        return 1
    end

    set ssh_dir $HOME/.ssh
    set ssh_config_path $ssh_dir/config
    set ssh_confd_dir $ssh_dir/conf.d
    test -f "$ssh_config_path"; and set files $ssh_config_path; or set files
    test -d "$ssh_confd_dir"; and set -a files ($fd . "$ssh_confd_dir" -tf -L)

    for file in $files
        echo "$file"
    end
end
