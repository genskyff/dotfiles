#!/usr/bin/env fish

status is-interactive; or return 0

command -q kitten; or return 0

alias s="kitten ssh"
