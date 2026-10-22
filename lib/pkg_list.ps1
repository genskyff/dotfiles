$scoop_main_list = @(
    "7zip"
    "ast-grep"
    "bat"
    "bottom"
    "delta"
    "difftastic"
    "dufs"
    "fastfetch"
    "fd"
    "ffmpeg"
    "fnox"
    "fzf"
    "gh"
    "gsudo"
    "hyperfine"
    "jq"
    "lazydocker"
    "less"
    "llvm"
    "lsd"
    "mingw-winlibs"
    "mise"
    "nmap"
    "nu"
    "pwsh"
    "pandoc"
    "ripgrep"
    "starship"
    "tlrc"
    "tokei"
    "uv"
    "zoxide"
) | ForEach-Object { "main/$_" }

$scoop_extras_list = @(
    "age"
    "dbx"
    "fluxdown"
    "lazygit"
    "listary"
    "localsend"
    "obs-studio"
    "obsidian"
    "pot"
    "potplayer"
    "qq-nt"
    "snipaste"
    "sublime-merge"
    "typora"
    "wechat"
) | ForEach-Object { "extras/$_" }

$scoop_lemon_bucket = "https://github.com/hoilc/scoop-lemon"
$scoop_lemon_list = @(
    "clippi"
    "piclist"
) | ForEach-Object { "lemon/$_" }

if ($env:CI -eq "true") {
    $scoop_main_list = @("main/mise")
}
