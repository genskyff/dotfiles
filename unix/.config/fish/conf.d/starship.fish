#!/usr/bin/env fish

status is-interactive; or return 0

command -q starship; or return 0
starship init fish | source
