#!/usr/bin/env fish

status is-interactive; or return 0

test (uname) = Darwin; and set -l brew_path /opt/homebrew/bin/brew
test (uname) = Linux; and set -l brew_path /home/linuxbrew/.linuxbrew/bin/brew
test -e $brew_path; or return 0
eval "$($brew_path shellenv)"
