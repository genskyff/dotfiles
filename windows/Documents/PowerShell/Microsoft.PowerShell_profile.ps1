if (Get-Command mise -ErrorAction SilentlyContinue) {
    mise activate pwsh --shims | Out-String | Invoke-Expression
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    starship init powershell | Out-String | Invoke-Expression
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell | Out-String | Invoke-Expression
}

Import-Module gsudoModule -Force
Import-Module PSReadLine -Force

Set-PSReadLineOption -HistorySearchCursorMovesToEnd

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -key Enter -Function ValidateAndAcceptLine

Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory

Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar
Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardChar
Set-PSReadLineKeyHandler -Chord Alt+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Alt+b -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine

Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Chord Ctrl+h -Function BackwardDeleteChar
Set-PSReadLineKeyHandler -Chord Alt+d -Function DeleteWord
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardDeleteLine

if (Get-Command less -ErrorAction SilentlyContinue) {
    $env:LESS = "-iRF"
}

if (Get-Command fzf -ErrorAction SilentlyContinue) {
    $env:FZF_DEFAULT_OPTS = '--cycle --ansi --height 60% --highlight-line --reverse --info inline --border --no-separator
                            --preview-window "hidden,border-left,60%"
                            --bind "alt-/:change-preview-window(90%|60%)"
                            --bind "alt-,:toggle-wrap"
                            --bind "alt-.:toggle-preview-wrap"
                            --bind "ctrl-/:toggle-preview"
                            --bind "alt-f:preview-page-down,alt-b:preview-page-up"'
}

function Open-Folder {
    param($Path = ".")
    Invoke-Item $Path
}

function Which-Command {
    param($Command)
    (Get-Command $Command).Path
}

function Lsd-Invoke {
    $params = @("-N") + $args
    lsd @params
}

function Ls-Long {
    $params = @("-l") + $args
    Lsd-Invoke @params
}

function Ls-All {
    $params = @("-A") + $args
    Lsd-Invoke @params
}

function Ls-Long-All {
    $params = @("-lA") + $args
    Lsd-Invoke @params
}

function Ls-Tree {
    $params = @("--tree", "--depth", "1") + $args
    Lsd-Invoke @params
}

function Ls-Pure {
    $params = @("--classic") + $args
    Lsd-Invoke @params
}

function Ls-Tree-Pure {
    $params = @("--classic") + $args
    Ls-Tree @params
}

function Git-Diff {
    $params = @("diff", "-w") + $args
    git @params
}

function Git-Pull {
    $params = @("pull") + $args
    git @params
}

function Git-Status {
    $params = @("status") + $args
    git @params
}

function Git-Switch {
    $params = @("switch") + $args
    git @params
}

function Git-Submodule-Status {
    $params = @("submodule", "status") + $args
    git @params
}

function Git-Submodule-Update {
    $params = @("submodule", "update") + $args
    git @params
}

function Git-Branch {
    if (!(git rev-parse --is-inside-work-tree)) { return }
    $branches = git branch
    $current_ref = git rev-parse --abbrev-ref HEAD
    $fzf_args = @(
        "--preview", 'git log {-1} --oneline --graph --color=always --date="format:%y/%m/%d" --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s"',
        "--bind", "start:toggle-preview",
        "--bind", "enter:become(git switch {-1})"
    )

    if ($current_ref -eq "HEAD") {
        $fzf_args += @("--header", $branches[0])
        $branches = $branches[1..($branches.Length - 1)]
    }

    $branches | fzf @fzf_args
}

function Git-Log {
    if (!(git rev-parse --is-inside-work-tree)) { return }
    git log --oneline `
        --date="format:%y/%m/%d" `
        --color=always `
        --format="%C(auto)%cd %h%d <%<(6,trunc)%an> %s" `
    | fzf --preview "git show --color=always {2}" `
        --bind "enter:become(git checkout {2})"
}

function Git-Reflog {
    if (!(git rev-parse --is-inside-work-tree)) { return }
    git reflog --color=always `
        --date="format:%y/%m/%d %H:%M" `
        --format="%C(auto)%cd %h%d %gs" `
    | fzf --preview "git show --color=always {3}" `
        --bind "enter:become(git checkout {3})"
}

function Git-Difft {
    $params = @("-c", "diff.external=difft", "diff") + $args
    git @params
}

Set-Alias -Name open -Value Open-Folder -Force
Set-Alias -Name which -Value Which-Command -Force

Set-Alias -Name ff -Value fastfetch -Force
Set-Alias -Name lad -Value lazydocker -Force
Set-Alias -Name lg -Value lazygit -Force
Set-Alias -Name sudo -Value gsudo -Force

Set-Alias -Name ls -Value Lsd-Invoke -Force
Set-Alias -Name ll -Value Ls-Long -Force
Set-Alias -Name la -Value Ls-All -Force
Set-Alias -Name lla -Value Ls-Long-All -Force
Set-Alias -Name lt -Value Ls-Tree -Force
Set-Alias -Name lp -Value Ls-Pure -Force
Set-Alias -Name ltp -Value Ls-Tree-Pure -Force

Set-Alias -Name gd -Value Git-Diff -Force
Set-Alias -Name gp -Value Git-Pull -Force
Set-Alias -Name gs -Value Git-Status -Force
Set-Alias -Name gw -Value Git-Switch -Force

Set-Alias -Name gss -Value Git-Submodule-Status -Force
Set-Alias -Name gsu -Value Git-Submodule-Update -Force

Set-Alias -Name gb -Value Git-Branch -Force
Set-Alias -Name gl -Value Git-Log -Force
Set-Alias -Name grl -Value Git-Reflog -Force
Set-Alias -Name gdt -Value Git-Difft -Force
