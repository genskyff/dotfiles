#!/usr/bin/env fish

status is-interactive; or return 0

set -gx fish_greeting
set fish_function_path (realpath $HOME/.config/fish/functions/**/) $fish_function_path
set fish_function_path (string join \n $fish_function_path | awk '!seen[$0]++')
