$env.config.buffer_editor = "code"
$env.config.show_banner = false

const autoload_dir = $nu.data-dir | path join "vendor/autoload"
if not ($autoload_dir | path exists) {
    mkdir $autoload_dir
}

const mise_config = $nu.data-dir | path join "vendor/autoload/mise.nu"
const starship_config = $nu.data-dir | path join "vendor/autoload/starship.nu"
const zoxide_config = $nu.data-dir | path join "vendor/autoload/zoxide.nu"

if not ($mise_config | path exists) {
    mise activate nu --shims | save -f $mise_config
}
if not ($starship_config | path exists) {
    starship init nu | save -f $starship_config
}
if not ($zoxide_config | path exists) {
    zoxide init nushell | save -f $zoxide_config
}
