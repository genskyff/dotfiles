module ssh-utils {
    export def ssh-config-list [] {
        let ssh_path = $nu.home-path | path join .ssh
        let ssh_config_path = $ssh_path | path join config
        let ssh_confd_path = $ssh_path | path join conf.d
        mut files = []

        if ($ssh_config_path | path exists) {
            $files ++= [$ssh_config_path]
        }

        if ($ssh_confd_path | path exists) {
           $files ++= (ls $ssh_confd_path | where type == "file" | get name | each { |conf| $ssh_path | path join $conf })
        }

        $files
    }
}

def --wrapped s [...argv] {
    use ssh-utils *

    let host = (ssh-config-list | if ($in | is-empty) {""} else {bat -p ...$in} | lines | find -r '^\s*Host\s+\S+' | find -v "*" | split column -r '\s+' | get column2 | to text | fzf --preview-window hidden)

    print "\e[?2004l"
    if ($host | is-not-empty) {
        ssh $host ...$argv
    }
}

def se [] {
    use ssh-utils *

    let ssh_path = $nu.home-path | path join .ssh
    let nth = ($ssh_path | split row '\' | length) + 1
    ssh-config-list | str join "\n" |
        fzf --with-nth $"($nth).." -d\ --preview-window hidden --bind $"enter:become\(use utils.nu edit; edit {})"
}
