#!/usr/bin/env fish

status is-interactive; or return 0

# EDITOR
if _is_gui; and command -q code
    set -gx EDITOR code
    set -gx VISUAL code
else if command -q hx
    set -gx EDITOR hx
else if command -q helix
    set -gx EDITOR helix
else if command -q nvim
    set -gx EDITOR nvim
else if command -q vim
    set -gx EDITOR vim
end

# LESS
if command -q less
    set -gx LESS -iRF
end
