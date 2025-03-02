$env.config = {
    "buffer_editor": "code",
    "show_banner": false
}

let autoload_dir = $nu.data-dir | path join "vendor/autoload"
if not ($autoload_dir | path exists) {
    mkdir $autoload_dir
}

let mise_config = $nu.data-dir | path join "vendor/autoload/mise.nu"
let starship_config = $nu.data-dir | path join "vendor/autoload/starship.nu"
let zoxide_config = $nu.data-dir | path join "vendor/autoload/zoxide.nu"

if not ($mise_config | path exists) {
    mise activate nu --shims | save -f $mise_config
}
if not ($starship_config | path exists) {
    starship init nu | save -f $starship_config
}
if not ($zoxide_config | path exists) {
    zoxide init nushell | save -f $zoxide_config
}

if (which fzf | is-not-empty) {
    $env.FZF_DEFAULT_OPTS = "
        --cycle --ansi --height 60% --highlight-line --reverse --info inline --border --no-separator
        --preview-window 'hidden,border-left,60%'
        --bind 'alt-/:change-preview-window(90%|60%)'
        --bind 'alt-,:toggle-wrap'
        --bind 'alt-.:toggle-preview-wrap'
        --bind 'ctrl-/:toggle-preview'
        --bind 'alt-f:preview-page-down,alt-b:preview-page-up'
    "
}

if (which less | is-not-empty) {
    $env.LESS = "-iRF"
}

def gb [] {
    if (git rev-parse --is-inside-work-tree) != 'true' { return }
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
    if (git rev-parse --is-inside-work-tree) != 'true' { return }
    git log --oneline --date="format:%y/%m/%d" --color=always --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s"
        | fzf --preview "git show --color=always {2}" --bind "enter:become(git checkout {2})"
}

def grl [] {
    if (git rev-parse --is-inside-work-tree) != 'true' { return }
    git reflog --color=always --date="format:%y/%m/%d %H:%M" --format="%C(auto)%cd %h%d %gs"
        | fzf --preview "git show --color=always {3}" --bind "enter:become(git checkout {3})"
}

alias ff = fastfetch
alias lg = lazygit
alias lad = lazydocker
alias sudo = gsudo

alias gw = git switch
alias gs = git status
alias gd = git diff -w
alias gp = git pull
alias gss = git submodule status
alias gsu = git submodule update
