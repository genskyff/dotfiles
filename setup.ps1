$ErrorActionPreference = "Stop"

$scoop_list_ = "bat delta fastfetch fzf git gitui gsudo lsd neovim ripgrep starship tokei zoxide"
$scoop_list = $scoop_list_ -split " "

$nvim_config_url = "https://github.com/genskyff/nvim.git"
$nvim_config_path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim"
$nvim_config_bak_path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim.bak"
$nvim_data_path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim-data"

$common_path = Join-Path -Path $PSScriptRoot -ChildPath "common\*"
$windows_path = Join-Path -Path $PSScriptRoot -ChildPath "windows\*"

Import-Module ./lib/color.ps1 -Force

if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    info "Scoop not found. Installing..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    ok "Scoop has been installed"
}

info "Installing packages..."
scoop bucket add extras
scoop update
scoop install $scoop_list

warn -n "Copy config files to overwrite existing configs? (y/N): "
$copy_config = Read-Host

if ($copy_config -eq 'Y' -or $copy_config -eq 'y') {
    info "Copying config files..."
    Copy-Item -Path $common_path -Destination ~\ -Recurse -Force
    Copy-Item -Path $windows_path -Destination ~\ -Recurse -Force
}

$is_exist_nvim_config = $false
if (Test-Path $nvim_config_path) {
    $items_in_directory = Get-ChildItem -Path $nvim_config_path
    if ($items_in_directory.Count -gt 0) {
        $is_exist_nvim_config = $true
    } else {
        Remove-Item $nvim_config_path -Force
    }
}

if ($is_exist_nvim_config) {
    warn -n "Existing nvim config, backup and use the new one? (y/N): "
    $use_new_nvim_config = Read-Host

    if ($use_new_nvim_config -eq 'Y' -or $use_new_nvim_config -eq 'y') {
        info "Backup the existing neovim config..."

        if (Test-Path $nvim_config_bak_path) {
            Remove-Item $nvim_config_bak_path -Recurse -Force
        }

        Move-Item $nvim_config_path -Destination $nvim_config_bak_path -Force
    } else {
        ok "All done"
        exit
    }
} else {
    if (Test-Path $nvim_data_path) {
        Remove-Item $nvim_data_path -Recurse -Force
    }
}

info "Cloning the neovim config repository..."
git clone $nvim_config_url $nvim_config_path

ok "All done"
