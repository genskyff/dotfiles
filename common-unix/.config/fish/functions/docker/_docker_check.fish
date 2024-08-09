#!/usr/bin/env fish

function _docker_check --description "Check if docker is installed and running"
    if not command -q docker; or command -v docker | string match -qr "^/mnt"
        echo -e "$(set_color red)Error$(set_color normal): 'docker' command not found" >&2
        return 1
    end

    set error_message (command docker version 2>&1 1>/dev/null)
    if test (string length -- "$error_message") -gt 0
        echo -e "$(set_color red)Error$(set_color normal): $error_message" >&2
        return 1
    end
end
