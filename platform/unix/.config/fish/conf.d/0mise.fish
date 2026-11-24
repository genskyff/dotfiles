test (uname -s) = Linux; or return 0
command -q mise; or return 0

if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end
