#!/bin/bash

set -e

script_path=$(realpath $(dirname "$0"))
. "$script_path/lib/color.sh"

if [[ $(uname -s) =~ ^[Dd]arwin ]]; then
  current_os="darwin"
elif grep -qiE "ID=[\"]?arch[\"]?|ID_LIKE=[\"]?arch[\"]?" /etc/os-release; then
  current_os="arch"
elif grep -qiE "ID=[\"]?debian[\"]?" /etc/os-release; then
  current_os="debian"
else
  error -n "Error: this script is only for "
  error "${bold_color}macOS${error_color}, ${bold_color}Arch${error_color} and ${bold_color}Debian${error_color}"
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
brew_list="bat curl dust fastfetch fd fish fzf gitui lsd neovim ripgrep starship tokei zellij zoxide"

# Arch
pacman_list="base-devel bat bind bottom curl dust fastfetch fd fish fzf git git-delta gitui libunwind lsd neovim net-tools ntp openbsd-netcat openssh ripgrep socat starship tokei unzip zellij zoxide"
yay_url=https://aur.archlinux.org/yay-bin.git
aur_list="git-credential-oauth ttf-maple"

# Debian
apt_list="bat bind9-dnsutils build-essential curl fd-find fish git htop iptables libunwind8 lsd neofetch net-tools netcat-openbsd ntp openssh-client openssh-server ripgrep socat tmux unzip virt-what"
apt_sid_list="fzf neovim zoxide"

nvim_config_url=https://github.com/genskyff/nvim.git
nvim_config_path=$HOME/.config/nvim

if [[ "$current_os" == "darwin" ]]; then
  if $is_superuser_privilege; then
    error "Error: this script cannot be run with superuser privileges"
    exit 1
  else
    if ! [[ -x "$(command -v brew)" ]]; then
      info "${bold_color}Homebrew${info_color} not found. Installing it..."
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
      ok "${bold_color}Homebrew${ok_color} has been installed"
    fi

    info "Updating the packages..."
    brew update

    info "\nInstalling packages..."
    brew install $brew_list
    brew cleanup
  fi
elif [[ "$current_os" == "arch" ]]; then
  info "Updating the packages..."
  if $is_superuser_privilege; then
    pacman -Syu --noconfirm
  else
    sudo pacman -Syu --noconfirm
  fi

  info "\nInstalling packages..."
  if $is_superuser_privilege; then
    pacman -S --needed --noconfirm $pacman_list
  else
    sudo pacman -S --needed --noconfirm $pacman_list

    if [[ "$current_user" != "root" ]]; then
      if ! [[ -x "$(command -v yay)" ]]; then
        info "\n${bold_color}yay${info_color} not found. Installing it..."

        if [[ -d "yay-bin" ]]; then
          if ! [[ $(ls -A "yay-bin") ]]; then
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
        ok "${bold_color}yay${ok_color} has been installed"
      fi

      info "\nInstalling packages from AUR..."
      yay -S --needed --noconfirm $aur_list
    fi
  fi
elif [[ "$current_os" == "debian" ]]; then
  info "Adding the unstable repository..."

  source_file_path=/etc/apt/sources.list
  sid_line="deb http://deb.debian.org/debian sid main"

  preferences_file_path=/etc/apt/preferences.d/sid
  preferences_line="Package: *\nPin: release a=unstable\nPin-Priority: 100"

  if [[ ! -f /etc/apt/sources.list ]] || ! grep -qR "^[^#]*sid main" "$source_file_path" /etc/apt/sources.list.d/; then
    if $is_superuser_privilege; then
      echo "$sid_line" | tee -a "$source_file_path" > /dev/null
    else
      echo "$sid_line" | sudo tee -a "$source_file_path" > /dev/null
    fi
  fi

  if [[ ! -f "$preferences_file_path" ]] || ! grep -q "^[^#]*Pin: release a=unstable" "$preferences_file_path"; then
    if $is_superuser_privilege; then
      echo -e "$preferences_line" | tee -a "$preferences_file_path" > /dev/null
    else
      echo -e "$preferences_line" | sudo tee -a "$preferences_file_path" > /dev/null
    fi
  fi

  info "\nUpdating the packages..."
  if $is_superuser_privilege; then
    apt update
    apt upgrade -y
  else
    sudo apt update
    sudo apt upgrade -y
  fi

  info "\nInstalling packages..."
  if $is_superuser_privilege; then
    apt install -y $apt_list
    apt install -t sid -y $apt_sid_list
  else
    sudo apt install -y $apt_list
    sudo apt install -t sid -y $apt_sid_list
  fi
fi

if $is_superuser_privilege && [[ "$current_user" != "root" ]]; then
  ok "\nAll done"
  exit
fi

info "\nSetting up the user shell config..."
if [[ "$current_os" == "darwin" ]]; then
  default_shell=$(dscl . -read "/Users/$current_user" UserShell | awk '{print $2}')
else
  default_shell=$(getent passwd "$current_user" | cut -d: -f7)
fi

bash_profile_path=$HOME/.bash_profile
bash_profile_content="[[ -f $HOME/.bashrc ]] && . $HOME/.bashrc"
bashrc_path=$HOME/.bashrc

zprofile_path=$HOME/.zprofile
zprofile_content="[[ -f $HOME/.zshrc ]] && . $HOME/.zshrc"
zshrc_path=$HOME/.zshrc

rc_file_content='[[ $- != *i* ]] && return\n[[ -x "$(command -v fish)" ]] && exec fish'

info "Current default shell: ${bold_color}${default_shell##*/}${info_color}"
if [[ "$default_shell" =~ .*/(da|ba)?sh$ ]]; then
  if [[ ! -f "$bash_profile_path" ]] || ! grep -q "$bash_profile_content" "$bash_profile_path"; then
    info "Writing the bash profile..."
    echo "$bash_profile_content" >> "$bash_profile_path"
    info "Writing the bashrc..."
    echo -e "$rc_file_content" >> "$bashrc_path"
  fi
elif [[ "$default_shell" =~ .*/zsh$ ]]; then
  if [[ ! -f "$zprofile_path" ]] || ! grep -q "$zprofile_content" "$zprofile_path"; then
    info "Writing the zprofile..."
    echo "$zprofile_content" >> "$zprofile_path"
    info "Writing the zshrc..."
    echo -e "$rc_file_content" >> "$zshrc_path"
  fi
fi

warn -n "\nCopy config files to overwrite existing configs? (y/N): "
read copy_config
copy_config=${copy_config:-n}

if [[ "$copy_config" == [yY] ]]; then
  info "Copying config files..."
  cp -a "$script_path"/common/. $HOME/
  cp -a "$script_path"/common-unix/. $HOME/

  if [[ "$current_os" == "drawin" ]]; then
    cp -a "$script_path"/macos/. $HOME/
  elif [[ "$current_os" == "debian" ]]; then
    cp -a "$script_path"/debian/. $HOME/
  fi
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
  warn -n "\nExisting nvim config, backup and use the new one? (y/N): "
  read use_new_nvim_config
  use_new_nvim_config=${use_new_nvim_config:-n}

  if [[ "$use_new_nvim_config" == [yY] ]]; then
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

info "\nCloning the neovim config repository..."
git clone "$nvim_config_url" "$nvim_config_path"
ok "\nAll done"
