Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module PSReadLine -Force
Import-Module gsudoModule -Force

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
Set-PSReadLineKeyHandler -Chord Alt+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardDeleteLine

function Open-Folder {
    param($Path = ".")
    Invoke-Item $Path
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

function Git-Branch {
    $params = @("branch") + $args
    git @params
}

function Git-Switch {
    $params = @("switch") + $args
    git @params
}

function Git-Status {
    $params = @("status") + $args
    git @params
}

function Git-Diff {
    $params = @("diff") + $args
    git @params
}

function Git-Log {
    $params = @("log", "--oneline", "--graph") + $args
    git @params
}

function Git-Pull {
    $params = @("pull") + $args
    git @params
}

function Git-Submodule-Update {
    $params = @("submodule", "update") + $args
    git @params
}

Set-Alias -Name open -Value Open-Folder -Force

Set-Alias -Name cat -Value bat -Force
Set-Alias -Name ff -Value fastfetch -Force
Set-Alias -Name lg -Value lazygit -Force
Set-Alias -Name sudo -Value gsudo -Force

Set-Alias -Name ls -Value Lsd-Invoke -Force
Set-Alias -Name ll -Value Ls-Long -Force
Set-Alias -Name la -Value Ls-All -Force
Set-Alias -Name lla -Value Ls-Long-All -Force
Set-Alias -Name lt -Value Ls-Tree -Force
Set-Alias -Name lp -Value Ls-Pure -Force
Set-Alias -Name ltp -Value Ls-Tree-Pure -Force

Set-Alias -Name gb -Value Git-Branch -Force
Set-Alias -Name gw -Value Git-Switch -Force
Set-Alias -Name gs -Value Git-Status -Force
Set-Alias -Name gd -Value Git-Diff -Force
Set-Alias -Name gl -Value Git-Log -Force
Set-Alias -Name gp -Value Git-Pull -Force
Set-Alias -Name gsu -Value Git-Submodule-Update -Force
