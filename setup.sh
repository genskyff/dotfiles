#!/usr/bin/env bash

set -e

script_path=$(realpath $(dirname "$0"))
. "$script_path/lib/color.sh"

if [[ $(uname) = Darwin ]]; then
    current_os="darwin"
elif grep -qiE "ID=[\"]?arch[\"]?|ID_LIKE=[\"]?arch[\"]?" /etc/os-release; then
    current_os="arch"
elif grep -qiE "ID=[\"]?debian[\"]?" /etc/os-release; then
    current_os="debian"
else
    error -n "Error: this script is only for "
    error "${light_magenta}macOS${error_color}, ${light_magenta}Arch${error_color} and ${light_magenta}Debian${error_color}"
    exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
    is_superuser_privilege=true
else
    is_superuser_privilege=false
fi

if [[ -n "$SUDO_USER" ]]; then
    current_user="$SUDO_USER"
else
    current_user="${USER:-$(whoami)}"
fi

# macOS
brew_list="bat bottom clang-format curl dust fastfetch fd fish fzf git-delta helix lazydocker lazygit lsd neovim onefetch ripgrep starship tokei wget xmake zellij zoxide"

# Arch
pacman_list="base-devel bat bind bottom clang curl docker docker-compose dust fastfetch fd fish fzf git git-delta helix lazygit less libunwind lsd neovim net-tools onefetch openbsd-netcat openssh ripgrep socat starship sudo tokei traceroute unzip wget xmake zellij zoxide"
yay_url=https://aur.archlinux.org/yay-bin.git
aur_list="git-credential-oauth lazydocker-bin"

# Debian
apt_list="bat bind9-dnsutils build-essential clang-format clangd curl docker docker-compose fd-find fish git iptables less libunwind8 net-tools netcat-openbsd openssh-client openssh-server procps ripgrep socat sudo traceroute vim unzip wget"
linux_brew_list="bottom dust fastfetch fzf git-credential-oauth git-delta helix lazydocker lazygit lsd neovim onefetch starship tokei xmake zellij zoxide"

nvim_config_url=https://github.com/genskyff/nvim.git
nvim_config_path=$HOME/.config/nvim

if [[ "$current_os" == "darwin" ]]; then
    if $is_superuser_privilege; then
        error "Error: this script cannot be run with superuser privileges"
        exit 1
    else
        if [[ ! -x "$(command -v brew)" ]]; then
            info "${light_magenta}Homebrew${info_color} not found. Installing..."
            bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            ok "${light_magenta}Homebrew${ok_color} has been installed"
        fi

        info "Updating and installing packages from Homebrew..."
        brew upgrade
        brew install $brew_list
        brew cleanup --prune=all
    fi
elif [[ "$current_os" == "arch" ]]; then
    info "\nUpdating and installing packages..."
    if $is_superuser_privilege; then
        pacman -Syyu --needed --noconfirm --color always $pacman_list
    else
        sudo pacman -Syyu --needed --noconfirm --color always $pacman_list

        if [[ ! -x "$(command -v yay)" ]]; then
            info "${light_magenta}yay${info_color} not found. Installing..."

            if [[ -d "yay-bin" ]]; then
                if [[ ! $(ls -A "yay-bin") ]]; then
                    rm -rf yay-bin
                    git clone "$yay_url"
                fi
            else
                git clone "$yay_url"
            fi

            cd yay-bin
            makepkg -si --noconfirm
            cd ..
            rm -rf yay-bin
            ok "${light_magenta}'yay'${ok_color} has been installed"
        fi

        info "\nUpdating and installing packages from AUR..."
        yay -Syyu --needed --noconfirm --color always $aur_list
    fi
elif [[ "$current_os" == "debian" ]]; then
    info "\nUpdating and installing packages..."
    if $is_superuser_privilege; then
        apt update
        apt upgrade -y
        apt install -y $apt_list
    else
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y $apt_list

        if [[ ! -x "$(command -v brew)" ]]; then
            info "${light_magenta}Homebrew${info_color} not found. Installing..."
            bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            ok "${light_magenta}Homebrew${ok_color} has been installed"
        fi

        info "\nUpdating and installing packages from Homebrew..."
        brew upgrade
        brew install $linux_brew_list
        brew cleanup --prune=all
    fi
fi

if $is_superuser_privilege && [[ "$current_user" != "root" ]]; then
    ok "\nAll done"
    exit
fi

info "\nSetting up the user shell config..."
if [[ "$current_os" == "darwin" ]]; then
    default_shell=$(basename $(dscl . -read "/Users/$current_user" UserShell | awk '{print $2}'))
else
    default_shell=$(basename $(getent passwd "$current_user" | cut -d: -f7))
fi

zprofile_path=$HOME/.zprofile
zprofile_content='[[ -f $HOME/.zshrc ]] && . $HOME/.zshrc'
zshrc_path=$HOME/.zshrc
zshrc_content='command -v fish >/dev/null && {
    export SHELL=$(which fish)
    [[ $- == *i* ]] && exec fish
}'

if [[ "$current_os" == "darwin" ]]; then
    if [[ ! -f "$zprofile_path" ]] || ! grep -q "$zprofile_content" "$zprofile_path"; then
        info "Writing to .zprofile..."
        echo "$zprofile_content" >>"$zprofile_path"
    fi

    if [[ ! -f "$zshrc_path" ]] || ! grep -q "$zshrc_content" "$zshrc_path"; then
        info "Writing to .zshrc..."
        echo "$zshrc_content" >>"$zshrc_path"
    fi
else
    if [[ "$default_shell" != "$(basename $(command -v fish))" ]]; then
        warn -n "Change the default shell to ${light_magenta}fish${warn_color}? (Y/n): "
        read answer
        answer=${answer:-y}
        if [[ "$answer" == [yY] ]]; then
            chsh -s "$(command -v fish | sed 's/sbin/bin/')" "$current_user"
        fi
    fi
fi

warn -n "Copy config files to overwrite existing configs? (y/N): "
read answer
answer=${answer:-n}

if [[ "$answer" == [yY] ]]; then
    info "Copying config files..."
    cp -a "$script_path"/common/. $HOME/
    cp -a "$script_path"/unix/. $HOME/
fi

is_exist_nvim_config=false
if [[ -d "$nvim_config_path" ]]; then
    if [[ $(ls -A "$nvim_config_path") ]]; then
        is_exist_nvim_config=true
    else
        rm -rf "$nvim_config_path"
    fi
fi

if $is_exist_nvim_config; then
    warn -n "Existing nvim config. Backup and use the new one? (y/N): "
    read answer
    answer=${answer:-n}

    if [[ "$answer" == [yY] ]]; then
        info "Backup the existing neovim config..."
        rm -rf $HOME/.config/nvim.bak
        mv "$nvim_config_path" $HOME/.config/nvim.bak
    else
        ok "\nAll done"
        exit
    fi
else
    rm -rf $HOME/.local/share/nvim $HOME/.local/state/nvim $HOME/.cache/nvim
fi

info "Cloning the neovim config repository..."
git clone "$nvim_config_url" "$nvim_config_path"
ok "\nAll done"
