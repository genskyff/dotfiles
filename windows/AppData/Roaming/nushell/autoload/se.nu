def se [] {
    let ssh_dir = $nu.home-path | path join .ssh
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
    let scripts_dir = $nu.default-config-dir | path join scripts
    $files | str join "\n" | fzf --with-nth $"($nth).." -d\ --preview-window hidden --bind $"enter:become\(nu ($scripts_dir | path join edit.nu) {}\)"
}
