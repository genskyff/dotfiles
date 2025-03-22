module git-utils {
    export def git-check [] {
        if (which git | is-empty) {
            error make -u {msg: "'git' command not found"}
        } else if (git rev-parse --is-inside-work-tree o+e>| $in) != "true" {
            error make -u {msg: "Not inside a git repository"}
        }
    }
}

def gb [] {
    use git-utils *
    git-check

    mut branches = git branch | lines
    let current_ref = git rev-parse --abbrev-ref HEAD
    mut fzf_args = [
        "--preview" 'git log {-1} --oneline --graph --color=always --date="format:%y/%m/%d" --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s"'
        "--bind" "start:toggle-preview"
        "--bind" "enter:become(git switch {-1})"
    ]

    if $current_ref == "HEAD" {
        $fzf_args ++= ["--header", $branches.0]
        $branches = $branches | skip 1
    }

    $branches | str join "\n" | fzf ...$fzf_args
}

def gl [] {
    use git-utils *
    git-check

    git log --oneline --date="format:%y/%m/%d" --color=always --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s"
        | fzf --preview "git show --color=always {2}" --bind "enter:become(git checkout {2})"
}

def grl [] {
    use git-utils *
    git-check

    git reflog --color=always --date="format:%y/%m/%d %H:%M" --format="%C(auto)%cd %h%d %gs"
        | fzf --preview "git show --color=always {3}" --bind "enter:become(git checkout {3})"
}
