let scripts_path = $nu.default-config-dir | path join scripts
if (which fzf | is-not-empty) {
    $env.FZF_DEFAULT_OPTS = $"--cycle --ansi --height 60% --highlight-line --reverse --info inline --border --no-separator
                            --with-shell 'nu -c'
                            --preview 'nu ($scripts_path | path join fzf_preview.nu) {}'
                            --preview-window 'hidden,border-left,60%'
                            --bind 'alt-/:change-preview-window\(90%|60%)'
                            --bind 'alt-,:toggle-wrap'
                            --bind 'alt-.:toggle-preview-wrap'
                            --bind 'ctrl-/:toggle-preview'
                            --bind 'alt-f:preview-page-down,alt-b:preview-page-up'"
}
