#!/usr/bin/env fish

function fish_function_edit --description "Edit fish function"
    set function_path $HOME/.config/fish/functions
    set files $function_path/**/*.fish
    set nth (math (string split '/' -- $function_path | count) + 1)
    set selected (string join \n $files | fzf --with-nth="$nth.." --delimiter='/' --query="$argv[1]" -1)

    if string length -- $selected &>/dev/null
        nvim $selected
    end
end
