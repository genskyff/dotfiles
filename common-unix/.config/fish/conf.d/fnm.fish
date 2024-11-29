#!/usr/bin/env fish

status is-interactive; or return

command -q fnm; or return
fnm env --use-on-cd --shell fish | source
