def s [...argv] {
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

    let host = (bat -p ...$files | find "Host " | split column ' ' | get column2 | where $it !~ '.*\..*' | to text | fzf --preview-window hidden)
    if ($host | is-not-empty) {
        ssh $host ...$argv
    }
}
