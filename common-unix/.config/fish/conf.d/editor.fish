#!/usr/bin/env fish

command -q code; and set -gx EDITOR code; and return
command -q nvim; and set -gx EDITOR nvim; and return
