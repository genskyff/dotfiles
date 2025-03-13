export def edit [...argv: string] {
    let editor = $env.config.buffer_editor
    if ($editor == "code") {
        code ...$argv
    } else if ($editor == "hx") {
        hx ...$argv
    } else {
        start $argv.0
    }
}

export def fzf_preview [argv: string] {
    let target = $argv | path expand
    let type = $target | path type

    if $type == "file" {
        bat --color always $target

    } else if $type == "dir" {
        lsd --color always --tree --depth 1 $target
    }
}
