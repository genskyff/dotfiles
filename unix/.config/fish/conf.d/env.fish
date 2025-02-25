# EDITOR
if command -q code; and _is_gui
    set -gx EDITOR code
else if command -q hx
    set -gx EDITOR hx
else if command -q helix
    set -gx EDITOR helix
else if command -q vim
    set -gx EDITOR vim
end

# LESS
if command -q less
    set -gx LESS -iRF
end
