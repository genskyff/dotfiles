test (uname) = Darwin; and set -l brew_path /opt/homebrew/bin/brew
test (uname) = Linux; and set -l brew_path /home/linuxbrew/.linuxbrew/bin/brew
test -f $brew_path; and eval "$($brew_path shellenv)"
