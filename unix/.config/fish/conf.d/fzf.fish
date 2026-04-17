command -q fzf; or return 0

status is-interactive; and fzf --fish | source

command -q fd; and set -l fd fd
command -q fdfind; and set -l fd fdfind

if set -q fd
    test (uname) = Darwin; and set -l exclude "-E Applications -E Library"

    set -gx FZF_DEFAULT_COMMAND "$fd -tf -td -L --color always $exclude"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "$fd -td -L --color always $exclude"
end

set -l fzf_color '--color "bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8"
    --color "fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC"
    --color "marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8"
    --color "selected-bg:#45475A"
    --color "border:#6C7086,label:#CDD6F4"'

set -gx FZF_DEFAULT_OPTS '--cycle --ansi --height 60% --highlight-line --reverse --info inline --border --no-separator
    --with-shell "fish -c"
    --preview "_fzf_preview {}"
    --preview-window "hidden,border-left,60%"
    --bind "alt-/:change-preview-window(90%|60%)"
    --bind "alt-,:toggle-wrap"
    --bind "alt-.:toggle-preview-wrap"
    --bind "ctrl-/:toggle-preview"
    --bind "alt-f:preview-page-down,alt-b:preview-page-up"' \
    $fzf_color
