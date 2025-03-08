$env.config = {
    buffer_editor: "code",
    show_banner: false
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
