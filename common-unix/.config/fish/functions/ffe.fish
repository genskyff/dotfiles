#!/usr/bin/env fish

function ffe --description "Edit fish function"
    set function_path $HOME/.config/fish/functions
    set files $function_path/**/*.fish
    set nth (math (string split / -- $function_path | count) + 1)
    test -n "$EDITOR"; or set EDITOR nvim
    string join \n $files \
        | fzf --with-nth "$nth.." --delimiter / --query "$argv" \
            --bind "start:toggle-preview" \
            --bind "enter:become($EDITOR {})"
end
