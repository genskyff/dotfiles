$env.SHELL = "nu"

if (which fzf | is-not-empty) {
    let fzf_color = '--color "bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8"
                            --color "fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC"
                            --color "marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8"
                            --color "selected-bg:#45475A"
                            --color "border:#6C7086,label:#CDD6F4"'
    $env.FZF_DEFAULT_OPTS = $"--cycle --ansi --height 60% --highlight-line --reverse --info inline --border --no-separator
                            --with-shell 'nu --config ($nu.config-path) -c'
                            --preview 'use utils.nu fzf_preview; fzf_preview {}'
                            --preview-window 'hidden,border-left,60%'
                            --bind 'alt-/:change-preview-window\(90%|60%)'
                            --bind 'alt-,:toggle-wrap'
                            --bind 'alt-.:toggle-preview-wrap'
                            --bind 'ctrl-/:toggle-preview'
                            --bind 'alt-f:preview-page-down,alt-b:preview-page-up'
                            ($fzf_color)"
}

if (which less | is-not-empty) {
    $env.LESS = "-iRF"
}

let vendor_autoload_dir = $nu.data-dir | path join vendor autoload
if not ($vendor_autoload_dir | path exists) {
    mkdir $vendor_autoload_dir
}

let mise_config = $nu.data-dir | path join vendor autoload mise.nu
if (which mise | is-not-empty) {
    if not ($mise_config | path exists) {
        mise activate nu --shims | save -f $mise_config
    }
} else {
    rm -f $mise_config
}

let starship_config = $nu.data-dir | path join vendor autoload starship.nu
if (which starship | is-not-empty) {
    if not ($starship_config | path exists) {
        starship init nu | save -f $starship_config
    }
    $env.STARSHIP_LOG = "error"
} else {
    rm -f $starship_config
}

let zoxide_config = $nu.data-dir | path join vendor autoload zoxide.nu
if (which zoxide | is-not-empty) {
    if not ($zoxide_config | path exists) {
        zoxide init nushell | save -f $zoxide_config
    }
} else {
    rm -f $zoxide_config
}
