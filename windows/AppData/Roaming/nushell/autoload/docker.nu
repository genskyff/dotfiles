module docker-utils {
    export def docker_check [] {
        if (which docker | is-empty) {
            error make -u {msg: "'docker' not found"}
        } else if (docker version o+e>| str contains error) {
            error make -u {msg: "docker is not running"}
        }
    }

    export def --wrapped container-list [...argv] {
        let all_containers = docker ps --format "{{.ID}} {{.Names}} {{.Status}}" ...$argv | lines | split column " " id name status
        let exited_containers = $all_containers | where status =~ Exited* | each { $"(ansi red)($in.id) ($in.name) \(Exited)(ansi reset)" }
        let running_containers = $all_containers | where status =~ Up* | each { $"(ansi green)($in.id) ($in.name)(ansi reset)" }
        $exited_containers ++ $running_containers | str join "\n"
    }
}

def da [] {
    use docker-utils *
    docker_check

    let fzf_args = [
        "--with-nth", "2",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", "enter:become(print {2})"
    ]

    let target = container-list | fzf ...$fzf_args
    docker attach $target
}

def dcp [-H ...rest] {
    use docker-utils *
    docker_check

    let rest_len = ($rest | length)
    if $rest_len < 1 or $rest_len > 2 {
        error make -u {msg: $"dcp: expected 1~2 arguments; got ($rest_len)"}
    }

    mut rest = $rest
    mut args = ""
    if $H {
        if ($rest | length) == 1 {
            $rest.1 = "$\"(docker exec {2} bash -c 'echo $HOME')\""
        }
        $args = $"($rest.0) {2}:($rest.1)"
    } else {
        if ($rest | length) == 1 {
            $rest.1 = pwd
        }
        $args = $"{2}:($rest.0) ($rest.1)"
    }

    let fzf_args = [
        "--with-nth", "2",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", $"enter:become\(docker cp --follow-link ($args))"
    ]

    container-list | fzf ...$fzf_args
}

def de --wrapped [...argv] {
    use docker-utils *
    docker_check

    let fzf_args = [
        "--with-nth", "2",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", "enter:become(print {2})"
    ]

    let target = container-list | fzf ...$fzf_args
    docker exec -it $target ...$argv
}

def dl [] {
    use docker-utils *
    docker_check

    let fzf_args = [
        "--with-nth", "2..",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", $"enter:become\(docker logs -f --since (date now | format date "%Y-%m-%dT%H:%M:%S") {2})"
    ]

    container-list -a | fzf ...$fzf_args
}

def dp [] {
    use docker-utils *
    docker_check

    let all_containers = container-list -a
    let total_count = $all_containers | lines | length
    let exited_count = $all_containers | lines | find Exited | length
    let running_count = $total_count - $exited_count
    let message = $"(ansi blue)Total: ($total_count) (ansi green)Running: ($running_count) (ansi red)Exited: ($exited_count)(ansi reset)"
    let fzf_args = [
        "--with-nth", "2..",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--header", $"($message)",
        "--bind", "start:toggle-preview"
    ]

    $all_containers | fzf ...$fzf_args
}

def dre [] {
    use docker-utils *
    docker_check

    let fzf_args = [
        "--with-nth", "2..", "--multi",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", "ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle,enter:become(docker restart {+2})"
    ]

    container-list -a | fzf ...$fzf_args
}

def drm [] {
    use docker-utils *
    docker_check

    let fzf_args = [
        "--with-nth", "2..", "--multi",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", "ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle,enter:become(docker rm -f {+2})"
    ]

    container-list -a | fzf ...$fzf_args
}
