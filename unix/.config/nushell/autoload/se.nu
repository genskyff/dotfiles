def se [] {
    let prefix = if ($nu.os-info | get name) == "windows" { "C:" } else { "" }
    let ssh_dir = $prefix | path join $env.HOMEPATH .ssh
    let ssh_config = $ssh_dir | path join config
    let ssh_confd_dir = $ssh_dir | path join conf.d
    mut files = []

    if ($ssh_config | path exists) {
        $files ++= [$ssh_config]
    }

    if ($ssh_confd_dir | path exists) {
       $files ++= (ls $ssh_confd_dir | where type == "file" | get name | each { |conf| $ssh_dir | path join $conf })
    }

    let nth = ($ssh_dir | split row '\' | length) + 1
    let delimiter = if ($nu.os-info | get name) == "windows" { '\' } else { '/' }
    let utils_dir = $nu.data-dir | path join utils
    $files | str join "\n" | fzf --with-nth $"($nth).." -d $delimiter --preview-window hidden --bind $"enter:become\(nu ($utils_dir | path join edit.nu) {}\)"
}
