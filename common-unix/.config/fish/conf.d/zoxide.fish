#!/usr/bin/env fish

status is-interactive; or return

command -q zoxide; or return
zoxide init fish | source
