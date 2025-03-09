$ErrorActionPreference = "Stop"

$scoop_list = "
7zip
bat
delta
deno
difftastic
fastfetch
fzf
gsudo
lazydocker
lazygit
less
llvm
localsend
lsd
mingw-winlibs-ucrt
mise
msys2
nilesoft-shell
nu
pandoc
potplayer
qbittorrent-enhanced
qq-nt
ripgrep
snipaste
starship
tlrc
tokei
typora
wechat
xmake
zoxide
"
$scoop_list = $scoop_list.Trim() -split "\n"

$scoop_lemon_bucket = "https://github.com/hoilc/scoop-lemon"
$scoop_lemon_list = "piclist"
$scoop_lemon_list = $scoop_lemon_list -split " " | ForEach-Object { "lemon/$_" }

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
scoop install git
scoop update

scoop bucket add extras
scoop bucket add versions
scoop install $scoop_list

scoop bucket add lemon $scoop_lemon_bucket
scoop install $scoop_lemon_list

warn -n "Copy config files to overwrite existing configs? (y/N): "
$answer = Read-Host

if ($answer -eq 'Y' -or $answer -eq 'y') {
    info "Copying config files..."
    Copy-Item -Path $common_path -Destination $HOME -Recurse -Force
    Copy-Item -Path $windows_path -Destination $HOME -Recurse -Force
}

ok "All done"
