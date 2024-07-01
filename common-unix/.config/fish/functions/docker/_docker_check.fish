function _docker_check
    if not command -q docker; or command -v docker | string match -qr "^/mnt"
        echo "$(set_color red)Error$(set_color normal): `docker` command not found" >&2
        return 1
    end

    set error_msg (command docker version 2>&1 1>/dev/null)
    test (string length -- "$error_msg") -gt 0
    and echo "$(set_color red)Error$(set_color normal): $error_msg" >&2
    and return 1
end
