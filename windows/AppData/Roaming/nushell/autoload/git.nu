def gb [] {
    if (which git | is-empty) or (git rev-parse --is-inside-work-tree) != 'true' { return }
    mut branches = git branch | lines
    let current_ref = git rev-parse --abbrev-ref HEAD
    mut fzf_args = [
        '--preview' 'git log {-1} --oneline --graph --date="format:%y/%m/%d" --color=always --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s"'
        '--bind' 'start:toggle-preview'
        '--bind' 'enter:become(git switch {-1})'
    ]

    if $current_ref == "HEAD" {
        $fzf_args ++= ['--header', $branches.0]
        $branches = $branches | skip 1
    }

    $branches | str join "\n" | fzf ...$fzf_args
}

def gl [] {
    if (which git | is-empty) or (git rev-parse --is-inside-work-tree) != 'true' { return }
    git log --oneline --date="format:%y/%m/%d" --color=always --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s"
        | fzf --preview "git show --color=always {2}" --bind "enter:become(git checkout {2})"
}

def grl [] {
    if (which git | is-empty) or (git rev-parse --is-inside-work-tree) != 'true' { return }
    git reflog --color=always --date="format:%y/%m/%d %H:%M" --format="%C(auto)%cd %h%d %gs"
        | fzf --preview "git show --color=always {3}" --bind "enter:become(git checkout {3})"
}
