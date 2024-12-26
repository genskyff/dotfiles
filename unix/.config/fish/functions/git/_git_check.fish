#!/usr/bin/env fish

function _git_check --description "Check if git is installed and a git repository"
    if not command -q git
        echo -e "$(set_color red)Error$(set_color normal): 'git' command not found" >&2
        return 1
    end

    set error_message (command git rev-parse --is-inside-work-tree 2>&1 1>/dev/null)
    if test (string length -- "$error_message") -gt 0
        echo -e "$(set_color red)Error$(set_color normal): $error_message" >&2
        return 1
    end
end
