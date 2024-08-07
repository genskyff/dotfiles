function fish_function_edit --description "Edit fish function"
    set function_path $HOME/.config/fish/functions
    set files $function_path/**/*.fish
    set selected (string join \n $files | string replace -r "^$function_path/" "" | fzf --exact --query="$argv[1]" -1)

    if string length -- $selected &>/dev/null
        nvim "$function_path/$selected"
    end
end
