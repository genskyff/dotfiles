export def --wrapped edit [...argv] {
    let editor = $env.config.buffer_editor

    if ($editor == "code") {
        code ...$argv
    } else if ($editor == "hx") {
        hx ...$argv
    } else {
        start $argv.0
    }
}

export def fzf_preview [argv] {
    let target = $argv | path expand
    let type = $target | path type

    if $type == "file" {
        bat --color always $target

    } else if $type == "dir" {
        lsd --color always --tree --depth 1 $target
    }
}

export def docker_fzf_preview [argv] {
    let fields = docker ps -a --filter $"id=($argv)" --format "{{.ID}}|{{.Image}}|{{.Command}}|{{.CreatedAt}}|{{.Status}}|{{.Ports}}|{{.Names}}"
    | split row "|"

    print $"(ansi blue)ID      (ansi reset)($fields.0)"
    print $"(ansi green)Image   (ansi reset)($fields.1)"
    print $"(ansi yellow)Command (ansi reset)($fields.2)"
    print $"(ansi cyan)Created (ansi reset)($fields.3)"
    print $"(ansi yellow)Status  (ansi reset)($fields.4)"
    print $"(ansi green)Ports   (ansi reset)($fields.5)"
    print $"(ansi blue)Name    (ansi reset)($fields.6)"
}
