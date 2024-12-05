#!/usr/bin/env fish

status is-interactive; or return

command -q kitten; or return

alias s="kitten ssh"
