$scoop_main_list = "
7zip
ast-grep
bat
delta
difftastic
dufs
fastfetch
fd
ffmpeg
fzf
git
gsudo
hyperfine
jaq
lazydocker
less
llvm
lsd
mise
msys2
nu
pandoc
ripgrep
sd
starship
tlrc
tokei
trippy
xmake
zellij
zoxide
"
$scoop_extras_list = "
lazygit
listary
localsend
pot
potplayer
qbittorrent-enhanced
qq-nt
snipaste
typora
wechat
"
$scoop_versions_list = "mingw-winlibs-ucrt"

$scoop_main_list = $scoop_main_list.Trim() -split "\n" | ForEach-Object { "main/$_" }
$scoop_extras_list = $scoop_extras_list.Trim() -split "\n" | ForEach-Object { "extras/$_" }
$scoop_versions_list = $scoop_versions_list.Trim() -split " " | ForEach-Object { "versions/$_" }

$scoop_lemon_bucket = "https://github.com/hoilc/scoop-lemon"
$scoop_lemon_list = "choose piclist"
$scoop_lemon_list = $scoop_lemon_list -split " " | ForEach-Object { "lemon/$_" }
