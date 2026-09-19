$env.SHELL = "nu"

if (which fzf | is-not-empty) {
    $env.FZF_DEFAULT_OPTS = "--cycle --ansi --height 60% --highlight-line --reverse --info inline --border --no-separator
                            --with-shell 'nu -c'
                            --preview 'use utils.nu fzf_preview; fzf_preview {}'
                            --preview-window 'hidden,border-left,60%'
                            --bind 'alt-/:change-preview-window(90%|60%)'
                            --bind 'alt-,:toggle-wrap'
                            --bind 'alt-.:toggle-preview-wrap'
                            --bind 'ctrl-/:toggle-preview'
                            --bind 'alt-f:preview-page-down,alt-b:preview-page-up'"
}

if (which less | is-not-empty) {
    $env.LESS = "-iRF"
}

let vendor_autoload_dir = $nu.data-dir | path join vendor autoload
if not ($vendor_autoload_dir | path exists) {
    mkdir $vendor_autoload_dir
}

def need-update [file: path] {
    if not ($file | path exists) {
        return true
    }

    (ls $file | first | get modified) < ((date now) - 7day)
}

let mise_config = $nu.data-dir | path join vendor autoload mise.nu
if (which mise | is-not-empty) {
    if (need-update $mise_config) {
        mise activate nu | save -f $mise_config
    }
} else {
    rm -f $mise_config
}

let starship_config = $nu.data-dir | path join vendor autoload starship.nu
if (which starship | is-not-empty) {
    if (need-update $starship_config) {
        starship init nu | save -f $starship_config
    }
    $env.STARSHIP_LOG = "error"
} else {
    rm -f $starship_config
}

let zoxide_config = $nu.data-dir | path join vendor autoload zoxide.nu
if (which zoxide | is-not-empty) {
    if (need-update $zoxide_config) {
        zoxide init nushell | save -f $zoxide_config
    }
} else {
    rm -f $zoxide_config
}
