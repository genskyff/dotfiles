def ssh-config-files [] {
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

    $files
}

def s [...argv] {
    let host = try {
        (bat -p ...(ssh-config-files | if ($in | is-empty) {''} else {$in}) | find "Host " | split column ' ' | get column2 | where $it !~ '.*\..*')
    } | to text | fzf --preview-window hidden

    if ($host | is-not-empty) {
        ssh $host ...$argv
    }
}

def se [] {
    let ssh_dir = $nu.home-path | path join .ssh
    let nth = ($ssh_dir | split row '\' | length) + 1
    let scripts_dir = $nu.default-config-dir | path join scripts
    ssh-config-files | str join "\n" |
        fzf --with-nth $"($nth).." -d\ --preview-window hidden --bind $"enter:become\(nu --config ($nu.config-path) ($scripts_dir | path join edit.nu) {})"
}
