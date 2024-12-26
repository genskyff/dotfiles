#!/usr/bin/env fish

status is-interactive; or return 0

command -q fnm; or return 0
fnm env --use-on-cd --shell fish | source
