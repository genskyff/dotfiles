def se [] {
    let ssh_dir = "C:" | path join $env.HOMEPATH .ssh
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
    let utils_dir = $nu.data-dir | path join utils
    $files | str join "\n" | fzf --with-nth $"($nth).." -d\ --preview-window hidden --bind $"enter:become\(nu ($utils_dir | path join edit.nu) {}\)"
}
