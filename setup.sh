#!/usr/bin/env bash

set -eo pipefail

script_dir=$(realpath "$(dirname "$0")")
. "$script_dir/lib/color.sh"
. "$script_dir/lib/pkg_list.sh"

os_kernel=$(uname -s)
os_arch=$(uname -m)

if [[ "$os_kernel" = "Darwin" ]] && [[ "$os_arch" = "arm64" ]]; then
    os_name="macos"
elif [[ "$os_kernel" = "Linux" ]]; then
    if grep -qiE "ID=[\"]?arch[\"]?|ID_LIKE=[\"]?arch[\"]?" /etc/os-release; then
        os_name="arch"
    elif grep -qiE "ID=[\"]?debian[\"]?" /etc/os-release; then
        os_name="debian"
    else
        error "Error${reset}: only support following Linux distributions:"
        echo "- Arch"
        echo "- Debian"
        exit 1
    fi
else
    error "Error${reset}: only support following operating systems:"
    echo "- macOS (Apple Silicon)"
    echo "- Linux"
    exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
    is_superuser_privilege=true
else
    is_superuser_privilege=false
fi

if [[ -n "$SUDO_USER" ]]; then
    os_user="$SUDO_USER"
else
    os_user="${USER:-$(whoami)}"
fi

if [[ "$os_name" == "macos" ]]; then
    if $is_superuser_privilege; then
        error "Error${reset}: cannot be run with superuser privileges"
        exit 1
    else
        if ! command -v brew >/dev/null 2>&1; then
            info "${light_magenta}Homebrew${info_color} not found. Installing..."
            bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/opt/homebrew/bin/brew shellenv)"
            ok "${light_magenta}Homebrew${ok_color} has been installed"
        fi

        info "Updating and installing packages from Homebrew..."
        brew upgrade
        brew install $brew_list
        brew cleanup --prune=all
    fi
elif [[ "$os_name" == "arch" ]]; then
    info "Updating and installing packages..."
    if $is_superuser_privilege; then
        pacman -Syyu --needed --noconfirm --color always $pacman_list
    else
        sudo pacman -Syyu --needed --noconfirm --color always $pacman_list

        if ! command -v "$aur_helper" >/dev/null 2>&1; then
            info "${light_magenta}${aur_helper}${info_color} not found. Installing..."

            if [[ ! -d "$aur_helper" ]] || [[ -z "$(ls -A "$aur_helper")" ]]; then
                rm -rf "$aur_helper"
                git clone "$aur_helper_url" "$aur_helper"
            fi

            cd "$aur_helper"
            makepkg -si --noconfirm
            cd ..
            rm -rf "$aur_helper"
            ok "${light_magenta}${aur_helper}${ok_color} has been installed"
        fi

        info "\nUpdating and installing packages from AUR..."
        $aur_helper -Syyu --needed --noconfirm --color always $aur_list
    fi
elif [[ "$os_name" == "debian" ]]; then
    info "Updating and installing packages..."

    if $is_superuser_privilege; then
        apt update
        apt upgrade -y
        apt install -y $debian_apt_list
    else
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y $debian_apt_list

        if [[ "$os_arch" == "x86_64" ]]; then
            if ! command -v brew >/dev/null 2>&1; then
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
        else
            warn "Skipping Homebrew installation on non-x86_64 linux architecture"
        fi
    fi
fi

if [[ "$os_kernel" == "Linux" ]] && [[ "$os_user" != "root" ]]; then
    if grep -q "^docker:" /etc/group && ! groups "$os_user" 2>/dev/null | grep -q docker; then
        sudo usermod -aG docker "$os_user"
        info "Added '$os_user' to docker group (requires logout/login)"
    fi
fi

if $is_superuser_privilege && [[ "$os_user" != "root" ]]; then
    ok "\nAll done"
    exit
fi

info "\nSetting up the user shell config..."
if [[ "$os_name" == "macos" ]]; then
    default_shell=$(basename "$(dscl . -read "/Users/$os_user" UserShell | awk '{print $2}')")
else
    default_shell=$(basename "$(getent passwd "$os_user" | cut -d: -f7)")
fi

fish_path=$(command -v fish || true)
if [[ "$os_kernel" == "Linux" ]] &&
    [[ -n "$fish_path" ]] &&
    [[ "$default_shell" != "$(basename "$fish_path")" ]]; then
    warn -n "Change the default shell to ${light_magenta}fish${warn_color}? (Y/n): "
    read -r answer
    answer=${answer:-y}
    fixed_fish_path=${fish_path//\/sbin\//\/bin\/}

    if [[ "$answer" == [yY] ]] && [[ -n "$fixed_fish_path" ]]; then
        if $is_superuser_privilege; then
            chsh -s "$fixed_fish_path" "$os_user"
        else
            sudo chsh -s "$fixed_fish_path" "$os_user"
        fi
    fi
fi

warn -n "Copy config files to overwrite existing configs? (y/N): "
read -r answer
answer=${answer:-n}

if [[ "$answer" == [yY] ]]; then
    info "Copying config files..."
    cp -a "$script_dir/common/." "$HOME/"
    cp -a "$script_dir/unix/." "$HOME/"
fi

ok "\nAll done"
