function fish_edit --description "Edit fish configuration"
    set config_path $HOME/.config/fish
    set files $config_path/config.fish $config_path/conf.d/*.fish
    set selected (string join \n $files | string replace -r "^$config_path/" "" | fzf --exact --query="$argv[1]" -1)

    if string length -- $selected &>/dev/null
        nvim "$config_path/$selected"
    end
end
