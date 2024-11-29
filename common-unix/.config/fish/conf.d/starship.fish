#!/usr/bin/env fish

status is-interactive; or return

command -q starship; or return
starship init fish | source
