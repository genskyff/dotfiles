if command -q code; and not command -s code | string match -qr "^/mnt"; and _is_gui
    set -gx EDITOR code
else if command -q nvim
    set -gx EDITOR nvim
else if command -q vim
    set -gx EDITOR vim
end

if command -q less
    set -gx LESS -iRF
end
