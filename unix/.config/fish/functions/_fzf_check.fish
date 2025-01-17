#!/usr/bin/env fish

function _fzf_check --description "Check fzf status"
    if not command -q fzf
        echo -e "$(set_color red)Error$(set_color normal): 'fzf' command not found" >&2
        return 1
    end
end
