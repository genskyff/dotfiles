function ffe --description "Edit fish function"
    _cmd_check fzf; or return 1

    set function_path $__fish_config_dir/functions
    set files $function_path/**/*.fish
    set nth (math (string split / $function_path | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." -d/ \
            --bind "start:toggle-preview" \
            --bind "enter:become($EDITOR {})"
end
