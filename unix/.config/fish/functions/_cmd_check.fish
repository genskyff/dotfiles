#!/usr/bin/env fish

function _cmd_check --description "Check command status"
    argparse -N1 quiet -- $argv

    set has_error 0
    set error_messages

    for cmd in $argv
        if not command -q "$cmd"
            set -q _flag_quiet; and return 1
            or set -a error_messages "$(set_color red)Error$(set_color normal): '$cmd' command not found"
        end
    end

    if not set -q _flag_quiet; and test (count $error_messages) -gt 0
        set has_error 1
        for message in $error_messages
            echo -e "$message" >&2
        end
    end

    return $has_error
end
