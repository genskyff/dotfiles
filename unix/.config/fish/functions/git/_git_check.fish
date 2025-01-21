#!/usr/bin/env fish

function _git_check --description "Check git status"
   _cmd_check git; or return 1

    set error_message (command git rev-parse --is-inside-work-tree 2>&1 1>/dev/null)
    if test (string length -- "$error_message") -gt 0
        echo -e "$(set_color red)Error$(set_color normal): $error_message" >&2
        return 1
    end
end
