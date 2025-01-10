#!/usr/bin/env fish

function _is_gui --description "Check shell environment"
    if set -q SSH_CLIENT; or set -q SSH_CONNECTION; or set -q SSH_TTY
        return 1
    else if test (uname) = Darwin; and pgrep -q Finder
        return 0
    else if test (uname) = Linux; and set -q DISPLAY
        return 0
    else
        return 1
    end
end
