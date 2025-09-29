#!/usr/bin/env bash

set -eo pipefail

script_path=$(realpath "$(dirname "$0")")
. "$script_path/lib/color.sh"
. "$script_path/lib/pkg_list.sh"

if [[ $(uname) = "Darwin" ]]; then
    current_os="darwin"
elif grep -qiE "ID=[\"]?arch[\"]?|ID_LIKE=[\"]?arch[\"]?" /etc/os-release; then
    current_os="arch"
elif grep -qiE "ID=[\"]?debian[\"]?" /etc/os-release; then
    current_os="debian"
else
    error "Error${reset}: this script is only for"
    echo "- macOS"
    echo "- Arch"
    echo "- Debian"
    exit 1
fi

current_os_family=$(uname)
current_arch=$(uname -m)

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

if [[ "$current_os" == "darwin" ]]; then
    if $is_superuser_privilege; then
        error "Error${reset}: this script cannot be run with superuser privileges"
        exit 1
    elif [[ "$current_arch" != "arm64" ]]; then
        error "Error${reset}: this script is only for Apple Silicon on macOS"
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
    info "Updating and installing packages..."
    if $is_superuser_privilege; then
        pacman -Syyu --needed --noconfirm --color always $pacman_list
    else
        sudo pacman -Syyu --needed --noconfirm --color always $pacman_list

        if [[ ! -x "$(command -v paru)" ]]; then
            info "${light_magenta}paru${info_color} not found. Installing..."

            if [[ -d "paru-bin" ]]; then
                if [[ ! $(ls -A "paru-bin") ]]; then
                    rm -rf paru-bin
                    git clone "$paru_url"
                fi
            else
                git clone "$paru_url"
            fi

            cd paru-bin
            makepkg -si --noconfirm
            cd ..
            rm -rf paru-bin
            ok "${light_magenta}paru${ok_color} has been installed"
        fi

        info "\nUpdating and installing packages from AUR..."
        paru -Syyu --needed --noconfirm --color always $aur_list
    fi
elif [[ "$current_os" == "debian" ]]; then
    info "Updating and installing packages..."

    if $is_superuser_privilege; then
        apt update
        apt upgrade -y
        apt install -y $debian_apt_list
    else
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y $debian_apt_list

        if [[ "$current_arch" == "x86_64" ]]; then
            if [[ ! -x "$(command -v brew)" ]]; then
                linux_brew_path=/home/linuxbrew/.linuxbrew/bin/brew
                if [[ ! -f "$linux_brew_path" ]]; then
                    info "${light_magenta}Homebrew${info_color} not found. Installing..."
                    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    ok "${light_magenta}Homebrew${ok_color} has been installed"
                fi
                eval "$($linux_brew_path shellenv)"
            fi

            info "Updating and installing packages from Homebrew..."
            brew upgrade
            brew install $debian_brew_list
            brew cleanup --prune=all
        fi
    fi
fi

if [[ "$current_os_family" == "Linux" ]] && [[ "$current_user" != "root" ]]; then
    if ! groups | grep -q docker; then
        if ! grep -E "^docker" /etc/group | grep -q "$current_user"; then
            sudo usermod -aG docker "$current_user"
            info "Added '$current_user' to docker group (requires logout/login)"
        fi
    fi
fi

if $is_superuser_privilege && [[ "$current_user" != "root" ]]; then
    ok "\nAll done"
    exit
fi

info "\nSetting up the user shell config..."
if [[ "$current_os" == "darwin" ]]; then
    default_shell=$(basename "$(dscl . -read "/Users/$current_user" UserShell | awk '{print $2}')")
else
    default_shell=$(basename "$(getent passwd "$current_user" | cut -d: -f7)")
fi

fish_path=$(command -v fish)
if [[ -n "$fish_path" ]] && [[ "$current_os" == "darwin" ]]; then
    zprofile_path=$HOME/.zprofile
    zprofile_content='[[ -f $HOME/.zshrc ]] && . $HOME/.zshrc'
    zshrc_path=$HOME/.zshrc
    zshrc_content='command -v fish >/dev/null && {
        export SHELL=$(which fish)
        [[ $- == *i* ]] && exec fish
    }'

    if [[ ! -f "$zprofile_path" ]] || ! grep -q "$zprofile_content" "$zprofile_path"; then
        info "Writing to .zprofile..."
        echo "$zprofile_content" >>"$zprofile_path"
    fi

    if [[ ! -f "$zshrc_path" ]] || ! grep -q "$zshrc_content" "$zshrc_path"; then
        info "Writing to .zshrc..."
        echo "$zshrc_content" >>"$zshrc_path"
    fi
elif [[ -n "$fish_path" ]] && [[ "$default_shell" != "$(basename "$fish_path")" ]]; then
    warn -n "Change the default shell to ${light_magenta}fish${warn_color}? (Y/n): "
    read -r answer
    answer=${answer:-y}
    fish_path_fix=${fish_path//sbin/bin}

    if [[ "$answer" == [yY] ]] && [[ -n "$fish_path_fix" ]]; then
        if $is_superuser_privilege; then
            chsh -s "$fish_path_fix" "$current_user"
        else
            sudo chsh -s "$fish_path_fix" "$current_user"
        fi
    fi
fi

warn -n "Copy config files to overwrite existing configs? (y/N): "
read -r answer
answer=${answer:-n}

if [[ "$answer" == [yY] ]]; then
    info "Copying config files..."
    cp -a "$script_path"/common/. "$HOME"/
    cp -a "$script_path"/unix/. "$HOME"/
fi

ok "\nAll done"
