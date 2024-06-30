function fish_reload --description "Reload fish configuration"
    . ~/.config/fish/config.fish
    for file in ~/.config/fish/conf.d/*.fish
        . $file
    end
end
