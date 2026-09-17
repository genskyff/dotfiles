module docker-utils {
    export def docker-check [] {
        if (which docker | is-empty) {
            error make -u {msg: "'docker' command not found"}
        } else if (docker version | complete).exit_code != 0 {
            error make -u {msg: "docker is not running"}
        }
    }

    export def --wrapped container-list [--header ...argv] {
        let all_containers = docker ps --format "{{.ID}} {{.Names}} {{.State}}" ...$argv | lines | split column " " id name state
        let exited_containers = $all_containers | where state == exited | each { $"(ansi red)($in.id) ($in.name)(ansi reset)" }
        let running_containers = $all_containers | where state == running | each { $"(ansi green)($in.id) ($in.name)(ansi reset)" }
        let other_containers = $all_containers | where state not-in [exited running] | each { $"(ansi yellow)($in.id) ($in.name)(ansi reset)" }
        let header_lines = if $header {
            [$"(ansi green)Running: ($running_containers | length) (ansi red)Exited: ($exited_containers | length) (ansi yellow)Other: ($other_containers | length)(ansi reset)"]
        } else {
            []
        }
        $header_lines ++ $exited_containers ++ $other_containers ++ $running_containers | str join "\n"
    }
}

def da [] {
    use docker-utils *
    docker-check

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
    docker-check

    let rest_len = ($rest | length)
    if $rest_len < 1 or $rest_len > 2 {
        error make -u {msg: $"dcp: expected 1~2 arguments; got ($rest_len)"}
    }

    let fzf_args = [
        "--with-nth", "2",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", "enter:become(print {2})"
    ]

    let target = container-list | fzf ...$fzf_args
    if ($target | is-empty) {
        return
    }

    mut rest = $rest
    if $H {
        if $rest_len == 1 {
            $rest.1 = (docker exec $target sh -c 'echo "$HOME"')
        }
        docker cp --follow-link $rest.0 $"($target):($rest.1)"
    } else {
        if $rest_len == 1 {
            $rest.1 = pwd
        }
        docker cp --follow-link $"($target):($rest.0)" $rest.1
    }
}

def de --wrapped [...argv] {
    use docker-utils *
    docker-check

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
    docker-check

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
    docker-check

    let output = container-list --header -a | lines
    let fzf_args = [
        "--with-nth", "2..",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--header", $output.0,
        "--bind", "start:toggle-preview"
    ]

    $output | skip 1 | str join "\n" | fzf ...$fzf_args
}

def dre [] {
    use docker-utils *
    docker-check

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
    docker-check

    let fzf_args = [
        "--with-nth", "2..", "--multi",
        "--preview", "use utils.nu docker_fzf_preview; docker_fzf_preview {1}",
        "--bind", "start:toggle-preview",
        "--bind", "ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle,enter:become(docker rm -f {+2})"
    ]

    container-list -a | fzf ...$fzf_args
}
