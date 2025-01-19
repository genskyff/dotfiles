#!/usr/bin/env fish

status is-interactive; or return 0

set -l brew_path /opt/homebrew/bin/brew
test -f $brew_path; and eval "$($brew_path shellenv)"
