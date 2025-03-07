#!/usr/bin/env bash

set -e

script_path=$(realpath $(dirname "$0"))
. "$script_path/lib/color.sh"
. "$script_path/lib/pkg_list.sh"

if [[ $(uname) = Darwin ]]; then
    current_os="darwin"
elif grep -qiE "ID=[\"]?arch[\"]?|ID_LIKE=[\"]?arch[\"]?" /etc/os-release; then
    current_os="arch"
elif grep -qiE "ID=[\"]?debian[\"]?" /etc/os-release; then
    current_os="debian"
elif grep -qiE "ID=[\"]?kali[\"]?" /etc/os-release; then
    current_os="kali"
else
    error "Error${reset}: this script is only for"
    echo "- macOS"
    echo "- Arch"
    echo "- Debian"
    echo "- Kali"
    exit 1
fi

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
            ok "${light_magenta}yay${ok_color} has been installed"
        fi

        info "\nUpdating and installing packages from AUR..."
        yay -Syyu --needed --noconfirm --color always $aur_list
    fi
elif [[ "$current_os" == "debian" ]] || [[ "$current_os" == "kali" ]]; then
    info "Updating and installing packages..."
    if [[ "$current_os" == "debian" ]]; then
        apt_list=$debian_apt_list
    elif [[ "$current_os" == "kali" ]]; then
        apt_list=$kali_apt_list
    fi

    if $is_superuser_privilege; then
        apt update
        apt upgrade -y
        apt install -y $apt_list
    else
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y $apt_list

        if [[ "$current_arch" == "x86_64" ]]; then
            if [[ ! -x "$(command -v brew)" ]]; then
                if [[ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
                    info "${light_magenta}Homebrew${info_color} not found. Installing..."
                    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    ok "${light_magenta}Homebrew${ok_color} has been installed"
                fi
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            fi

            if [[ "$current_os" == "debian" ]]; then
                linux_brew_list=$debian_brew_list
            elif [[ "$current_os" == "kali" ]]; then
                linux_brew_list=$kali_brew_list
            fi

            info "Updating and installing packages from Homebrew..."
            brew upgrade
            brew install $linux_brew_list
            brew cleanup --prune=all
        fi
    fi
fi

if [[ "$current_os" != "darwin" ]] && [[ "$current_user" != "root" ]] then
    if grep -qiE "^docker" /etc/group; then
        info "Adding the user to the docker group..."
        sudo usermod -aG docker "$current_user"
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

if [[ "$current_os" == "darwin" ]]; then
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
else
    if [[ "$default_shell" != "$(basename $(command -v fish))" ]]; then
        warn -n "Change the default shell to ${light_magenta}fish${warn_color}? (Y/n): "
        read answer
        answer=${answer:-y}
        if [[ "$answer" == [yY] ]]; then
            if $is_superuser_privilege; then
                chsh -s "$(command -v fish | sed 's/sbin/bin/')" "$current_user"
            else
                sudo chsh -s "$(command -v fish | sed 's/sbin/bin/')" "$current_user"
            fi
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

ok "\nAll done"
