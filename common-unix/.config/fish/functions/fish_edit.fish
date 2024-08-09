function fish_edit --description "Edit fish configuration"
    set config_path $HOME/.config/fish
    set files $config_path/config.fish $config_path/conf.d/*.fish
    set nth (math (string split '/' -- $config_path | count) + 1)
    set selected (string join \n $files | fzf --with-nth="$nth.." --delimiter='/' --query="$argv[1]" -1)

    if string length -- $selected &>/dev/null
        nvim $selected
    end
end
