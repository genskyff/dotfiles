def main [argv: string] {
    let target = echo $argv | path expand
    let type = echo $target | path type

    if $type == "file" {
        bat --color always $target

    } else if $type == "dir" {
        lsd --color always --tree --depth 1 $target
    }
}
