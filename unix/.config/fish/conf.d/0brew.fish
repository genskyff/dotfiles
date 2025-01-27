set -l brew_path /opt/homebrew/bin/brew
test -f $brew_path; and eval "$($brew_path shellenv)"
