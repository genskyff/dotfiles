#!/usr/bin/env fish

status is-interactive; or return 0

command -q brew; or return 0
test (uname) = "Linux"; and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
