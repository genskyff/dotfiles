#!/usr/bin/env fish

function _cmd_check --description "Check command status"
    test -z "$argv[1]"; and return 1

    if not command -q "$argv[1]"
        echo -e "$(set_color red)Error$(set_color normal): '$argv[1]' command not found" >&2
        return 1
    end
end
