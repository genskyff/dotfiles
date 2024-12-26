#!/usr/bin/env fish

# EDITOR
if command -q code
    set -gx EDITOR code
else if command -q nvim
    set -gx EDITOR nvim
end

# LESS
if command -q less
    set -gx LESS -iRF
end
