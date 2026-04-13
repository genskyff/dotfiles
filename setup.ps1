$ErrorActionPreference = "Stop"

. "$PSScriptRoot/lib/color.ps1"
. "$PSScriptRoot/lib/pkg_list.ps1"

$common_path = Join-Path -Path $PSScriptRoot -ChildPath "common\*"
$windows_path = Join-Path -Path $PSScriptRoot -ChildPath "windows\*"

if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    info "'scoop' not found. Installing..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    ok "'scoop' has been installed"
}

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

info "Installing packages..."
scoop install git
scoop update

Add-ScoopBucket extras
Add-ScoopBucket versions
scoop install $scoop_main_list
scoop install $scoop_extras_list
scoop install $scoop_versions_list

Add-ScoopBucket lemon $scoop_lemon_bucket
scoop install $scoop_lemon_list

warn -n "Copy config files to overwrite existing configs? (y/N): "
$answer = Read-Host

if ($answer -eq "Y" -or $answer -eq "y") {
    info "Copying config files..."
    Copy-Item -Path $common_path -Destination $HOME -Recurse -Force
    Copy-Item -Path $windows_path -Destination $HOME -Recurse -Force
}

ok "All done"
