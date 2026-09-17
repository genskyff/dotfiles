$env:SHELL = "pwsh"

if (Get-Command code -ErrorAction SilentlyContinue) {
    $env:EDITOR = "code"
}

if (Get-Command mise -ErrorAction SilentlyContinue) {
    $init = mise activate pwsh | Out-String
    if ($init) {
        Invoke-Expression $init
    }
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    starship init powershell | Out-String | Invoke-Expression
    $env:STARSHIP_LOG = "error"
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell | Out-String | Invoke-Expression
}

if (Get-Command gsudo -ErrorAction SilentlyContinue) {
    Import-Module gsudoModule -Force
}

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

function BT { btm -b @args }

function Lsd-Invoke { lsd -N @args }
function Ls-Long { lsd -Nl @args }
function Ls-All { lsd -NA @args }
function Ls-Long-All { lsd -NlA @args }
function Ls-Tree { lsd -N --tree --depth 1 @args }
function Ls-Pure { lsd -N --classic @args }
function Ls-Tree-Pure { lsd -N --classic --tree --depth 1 @args }

function Git-Diff { git diff -w @args }
function Git-Pull { git pull @args }
function Git-Status { git status @args }
function Git-Switch { git switch @args }
function Git-Submodule-Status { git submodule status @args }
function Git-Submodule-Update { git submodule update @args }
function Git-Difft { git -c diff.external=difft diff @args }

function Git-Branch {
    if (!(git rev-parse --is-inside-work-tree)) { return }
    $branches = git branch
    $current_ref = git rev-parse --abbrev-ref HEAD
    $fzf_args = @(
        "--preview", 'git log {-1} --oneline --graph --color=always --date="format:%y/%m/%d" --format="%C(auto)%ad %h%d <%<(6,trunc)%an> %s"',
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
        --format="%C(auto)%ad %h%d <%<(6,trunc)%an> %s" `
    | fzf --preview "git show --color=always {2}" `
        --bind "enter:become(git checkout {2})"
}

function Git-Reflog {
    if (!(git rev-parse --is-inside-work-tree)) { return }
    git reflog --color=always `
        --date="format:%y/%m/%d %H:%M" `
        --format="%C(auto)%ad %h%d %gs" `
    | fzf --preview "git show --color=always {3}" `
        --bind "enter:become(git checkout {3})"
}

Set-Alias -Name open -Value Open-Folder -Force
Set-Alias -Name which -Value Which-Command -Force

Set-Alias -Name ff -Value fastfetch -Force
Set-Alias -Name hf -Value hyperfine -Force
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
