export def --wrapped edit [...argv] {
    let editor = $env.config.buffer_editor

    if ($editor | is-not-empty) {
        run-external $editor ...$argv
    } else {
        start $argv.0
    }
}

export def fzf_preview [argv] {
    let target = $argv | path expand
    let type = $target | path type | default ""

    if $type == "file" {
        bat --color always $target

    } else if $type == "dir" {
        lsd --color always --tree --depth 1 $target
    }
}

export def docker_fzf_preview [argv] {
    let fields = docker ps -a --filter $"id=($argv)" --format json | from json

    print $"(ansi blue)ID      (ansi reset)($fields.ID)"
    print $"(ansi green)Image   (ansi reset)($fields.Image)"
    print $"(ansi yellow)Command (ansi reset)($fields.Command)"
    print $"(ansi cyan)Created (ansi reset)($fields.CreatedAt)"
    print $"(ansi yellow)Status  (ansi reset)($fields.Status)"
    print $"(ansi green)Ports   (ansi reset)($fields.Ports)"
    print $"(ansi blue)Name    (ansi reset)($fields.Names)"
}
