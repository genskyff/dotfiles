#!/usr/bin/env fish

status is-interactive; or return

command -q code; and set -gx EDITOR code; and return
command -q nvim; and set -gx EDITOR nvim; and return
