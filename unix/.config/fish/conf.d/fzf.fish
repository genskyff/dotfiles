#!/usr/bin/env fish

status is-interactive; or return 0

command -q fzf; or return 0
fzf --fish | source

set -l fd
if command -q fd
    set fd fd
else if command -q fdfind
    set fd fdfind
end

if set -q fd; and test -n "$fd"
    test (uname) = Darwin; and set exclude "-E Applications -E Library"

    set -gx FZF_CTRL_T_COMMAND "$fd -tf -td -tl -L --color always $exclude"
    set -gx FZF_ALT_C_COMMAND "$fd -td -L --color always $exclude"
    set -gx FZF_DEFAULT_COMMAND "$fd -tf -td -tl -L --color always $exclude"
end

set -gx FZF_DEFAULT_OPTS "--cycle --ansi --height 60% --highlight-line --reverse --info inline --border --no-separator \
    --preview 'fish $__fish_config_dir/functions/_fzf_preview.fish {}' \
    --preview-window 'hidden,border-left,60%' \
    --bind 'alt-/:change-preview-window(90%|60%)' \
    --bind 'alt-,:toggle-wrap' \
    --bind 'alt-.:toggle-preview-wrap' \
    --bind 'ctrl-/:toggle-preview' \
    --bind 'alt-f:preview-page-down,alt-b:preview-page-up'"
