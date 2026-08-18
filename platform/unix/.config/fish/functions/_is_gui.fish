function _is_gui --description "Check shell environment"
    if set -q SSH_CLIENT; or set -q SSH_CONNECTION; or set -q SSH_TTY
        return 1
    else if test (uname -s) = Darwin; and pgrep -q Finder
        return 0
    else if test (uname -s) = Linux; and begin
            set -q DISPLAY; or set -q WAYLAND_DISPLAY
        end
        return 0
    else
        return 1
    end
end
