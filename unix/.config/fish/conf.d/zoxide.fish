#!/usr/bin/env fish

status is-interactive; or return 0

command -q zoxide; or return 0
zoxide init fish | source
