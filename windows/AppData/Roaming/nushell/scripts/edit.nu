def main [argv: string] {
    if (which code | is-not-empty) {
        code $argv
    } else if (which hx | is-not-empty) {
        hx $argv
    } else {
        start $argv
    }
}
