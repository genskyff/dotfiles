$ErrorActionPreference = "Stop"

$scoop_list = "bat bun delta fastfetch git gsudo lazygit less llvm lsd nilesoft-shell pandoc ripgrep starship tokei xmake zoxide"
$scoop_list = $scoop_list -split " "

$common_path = Join-Path -Path $PSScriptRoot -ChildPath "common\*"
$windows_path = Join-Path -Path $PSScriptRoot -ChildPath "windows\*"

Import-Module ./lib/color.ps1 -Force

if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    info "'Scoop' not found. Installing..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    ok "'Scoop' has been installed"
}

info "Installing packages..."
scoop bucket add extras
scoop update
scoop install $scoop_list

warn -n "Copy config files to overwrite existing configs? (y/N): "
$answer = Read-Host

if ($answer -eq 'Y' -or $answer -eq 'y') {
    info "Copying config files..."
    Copy-Item -Path $common_path -Destination $HOME -Recurse -Force
    Copy-Item -Path $windows_path -Destination $HOME -Recurse -Force
}

ok "All done"
