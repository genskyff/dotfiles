#!/usr/bin/env fish

function _cmd_check --description "Check command status"
    argparse -N1 fn quiet -- $argv

    set has_error 0
    set error_messages

    for cmd in $argv
        if not command -q "$cmd"; and not set -q _flag_fn
            set -a error_messages "$(set_color red)Error$(set_color normal): '$cmd' command not found"
        else if not command -q "$cmd"; and set -q _flag_fn; and not functions -q "$cmd"
            set -a error_messages "$(set_color red)Error$(set_color normal): '$cmd' command not found"
        end
    end

    if test (count $error_messages) -gt 0
        set has_error 1
    end

    if not set -q _flag_quiet; and test $has_error -eq 1
        for message in $error_messages
            echo -e "$message" >&2
        end
    end

    return $has_error
end
