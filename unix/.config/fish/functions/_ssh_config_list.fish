function _ssh_config_list --description "List ssh configuration files"
    if _cmd_check -q fd
        set fd fd
    else if _cmd_check -q fdfind
        set fd fdfind
    else
        echo -e "$(set_color red)Error$(set_color normal): 'fd' command not found" >&2
        return 1
    end

    set ssh_path $HOME/.ssh
    set ssh_config_path $ssh_path/config
    set ssh_confd_path $ssh_path/conf.d
    test -f $ssh_config_path; and set list $ssh_config_path; or set list
    test -d $ssh_confd_path; and set -a list ($fd . $ssh_confd_path -tf -L)

    for file in $list
        echo "$file"
    end
end
