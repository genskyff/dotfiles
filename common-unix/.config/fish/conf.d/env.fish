#!/usr/bin/env fish

# EDITOR
if command -q code
    set -gx EDITOR code
else if command -q nvim
    set -gx EDITOR nvim
end

# LESS
command -q less; and set -gx LESS -I
