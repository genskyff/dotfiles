$env.config.show_banner = false
$env.config.status_line.enable = false

if (which code | is-not-empty) {
    $env.config.buffer_editor = "code"
    $env.EDITOR = "code"
}
