function se --description "Edit ssh configuration"
    _cmd_check fzf; or return 1
    if _cmd_check --quiet fd
        set fd fd
    else if _cmd_check --quiet fdfind
        set fd fdfind
    else
        echo -e "$(set_color red)Error$(set_color normal): 'fd' command not found" >&2
        return 1
    end

    set ssh_path $HOME/.ssh
    set ssh_config_path $ssh_path/config
    set ssh_confd_path $ssh_path/conf.d
    test -f $ssh_config_path; and set files $ssh_config_path; or set files
    test -d $ssh_confd_path; and set -a files ($fd . $ssh_confd_path -tf -L)
    set nth (math (string split / -- $ssh_path | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." -d/ \
            --preview-window hidden \
            --bind "enter:become($EDITOR {})"
end
