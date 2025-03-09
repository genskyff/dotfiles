def main [...argv: string] {
    let editor = $env.config.buffer_editor
    if ($editor == "code") {
        code ...$argv
    } else if ($editor == "hx") {
        hx ...$argv
    } else {
        start $argv.0
    }
}
