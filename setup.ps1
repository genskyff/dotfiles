$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

. "$PSScriptRoot/lib/color.ps1"
. "$PSScriptRoot/lib/pkg_list.ps1"

function Add-ScoopBucket {
    param([string]$Name, [string]$Url = "")

    $existing = scoop bucket list | Select-Object -ExpandProperty Name
    if ($existing -notcontains $Name) {
        if ($Url) {
            scoop bucket add $Name $Url
        }
        else {
            scoop bucket add $Name
        }
    }
}

if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    info "'scoop' not found. Installing..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    ok "'scoop' has been installed"
}

info "Installing packages..."
scoop install git
scoop update
scoop install $scoop_main_list

Add-ScoopBucket extras
scoop install $scoop_extras_list

Add-ScoopBucket versions
scoop install $scoop_versions_list

Add-ScoopBucket lemon $scoop_lemon_bucket
scoop install $scoop_lemon_list

if ($env:DF_CONFIG -eq "1") {
    $answer = "y"
}
elseif ($env:DF_CONFIG -eq "0") {
    $answer = "n"
}
else {
    warn -n "Apply config files? (y/N): "
    $answer = Read-Host
}

if ($answer -eq "Y" -or $answer -eq "y") {
    if (-Not (Get-Command mise -ErrorAction SilentlyContinue)) {
        error "'mise' not found. Cannot apply config files"
        exit 1
    }

    info "Applying config files..."
    mise -C $PSScriptRoot trust -ay
    mise -C $PSScriptRoot bootstrap dotfiles apply -y
}

ok "All done"
