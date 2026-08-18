function ffe --description "Edit fish function"
    _cmd_check fzf; or return 1

    set function_dir $__fish_config_dir/functions
    set files $function_dir/**/*.fish
    set nth (math (string split / "$function_dir" | count) + 1)
    string join \n $files \
        | fzf --with-nth "$nth.." -d/ \
        --bind "start:toggle-preview" \
        --bind "enter:become($EDITOR {})"
end
