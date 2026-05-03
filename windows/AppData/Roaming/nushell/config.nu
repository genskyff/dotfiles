$env.config.show_banner = false

if (which code | is-not-empty) {
    $env.config.buffer_editor = "code"
    $env.EDITOR = "code"
}
