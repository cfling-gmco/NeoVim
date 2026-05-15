#!/usr/bin/env bash
set -e
OS="$(uname -s)"
install_packages() {
  if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew &>/dev/null; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install neovim tmux curl git lazygit fd
    brew install --cask font-jetbrains-mono-nerd-font ghostty
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --needed --noconfirm neovim tmux curl git lazygit fd ttf-jetbrains-mono-nerd
  elif command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y neovim tmux curl git fd-find unzip
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar -xf /tmp/lazygit.tar.gz -C /tmp
    sudo install /tmp/lazygit /usr/local/bin
    rm -f /tmp/lazygit.tar.gz /tmp/lazygit
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd 2>/dev/null || true
    mkdir -p ~/.local/share/fonts
    curl -Lo /tmp/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
    rm -f /tmp/JetBrainsMono.zip
    fc-cache -fv
  fi
}
setup_lazyvim() {
  [[ -d ~/.config/nvim ]] && rm -rf ~/.config/nvim.bak && mv ~/.config/nvim ~/.config/nvim.bak
  [[ -d ~/.local/share/nvim ]] && rm -rf ~/.local/share/nvim.bak && mv ~/.local/share/nvim ~/.local/share/nvim.bak
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
}
setup_dotfiles() {
  [[ -d ~/.dotfiles ]] && rm -rf ~/.dotfiles
  git clone https://github.com/cfling-gmco/NeoVim ~/.dotfiles
  mkdir -p ~/.config/nvim/lua/config ~/.config/nvim/lua/plugins
  ln -sf ~/.dotfiles/.config/nvim/lua/config/options.lua ~/.config/nvim/lua/config/options.lua
  ln -sf ~/.dotfiles/.config/nvim/lua/plugins/supermaven.lua ~/.config/nvim/lua/plugins/supermaven.lua
  ln -sf ~/.dotfiles/.config/nvim/lua/plugins/snacks.lua ~/.config/nvim/lua/plugins/snacks.lua
  ln -sf ~/.dotfiles/.config/nvim/lua/plugins/extras.lua ~/.config/nvim/lua/plugins/extras.lua
  ln -sf ~/.dotfiles/.config/nvim/lua/plugins/rose-pine.lua ~/.config/nvim/lua/plugins/rose-pine.lua
  ln -sf ~/.dotfiles/.config/nvim/lua/plugins/illuminate.lua ~/.config/nvim/lua/plugins/illuminate.lua
  ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
}
setup_tmux() {
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}
echo "installing packages..."
install_packages
echo "setting up lazyvim..."
setup_lazyvim
echo "cloning dotfiles..."
setup_dotfiles
echo "setting up tmux..."
setup_tmux
echo "done. next steps:"
echo "  1. open nvim and wait for plugins to install"
echo "  2. run :SupermavenUseFree"
echo "  3. start tmux: tmux new -s main"
echo "  4. inside tmux: tmux source ~/.tmux.conf && press Ctrl+Space then I"
