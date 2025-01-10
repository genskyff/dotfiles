#!/usr/bin/env fish

status is-interactive; or return 0

set -l brew_path /home/linuxbrew/.linuxbrew/bin/brew
test (uname) = "Linux"; and test -e $brew_path; or return 0
eval "$($brew_path shellenv)"
