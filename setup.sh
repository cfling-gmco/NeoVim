#!/usr/bin/env bash
set -e

OS="$(uname -s)"
ARCH="$(uname -m)"

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
    sudo apt install -y neovim tmux curl git fd-find
    # lazygit not in apt, install via binary
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar -xf /tmp/lazygit.tar.gz -C /tmp
    sudo install /tmp/lazygit /usr/local/bin
    # fd is fd-find on ubuntu, symlink it
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd 2>/dev/null || true
    # nerd font
    mkdir -p ~/.local/share/fonts
    curl -Lo /tmp/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
    fc-cache -fv
  fi
}

setup_lazyvim() {
  [[ -d ~/.config/nvim ]] && mv ~/.config/nvim ~/.config/nvim.bak
  [[ -d ~/.local/share/nvim ]] && mv ~/.local/share/nvim ~/.local/share/nvim.bak
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
}

write_nvim_configs() {
  # options
  cat > ~/.config/nvim/lua/config/options.lua << 'EOF'
vim.opt.relativenumber = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
EOF

  # supermaven
  cat > ~/.config/nvim/lua/plugins/supermaven.lua << 'EOF'
return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({})
  end,
}
EOF

  # snacks explorer pinned
  cat > ~/.config/nvim/lua/plugins/snacks.lua << 'EOF'
return {
  "folke/snacks.nvim",
  opts = {
    explorer = { replace_netrw = true },
  },
}
EOF

  # language extras
  cat > ~/.config/nvim/lua/plugins/extras.lua << 'EOF'
return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.lang.python" },
}
EOF
}

setup_tmux() {
  cat > ~/.tmux.conf << 'EOF'
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1
set -g prefix C-Space
unbind C-b
bind C-Space send-prefix
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
run '~/.tmux/plugins/tpm/tpm'
EOF

  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

echo "installing packages..."
install_packages

echo "setting up lazyvim..."
setup_lazyvim

echo "writing nvim configs..."
write_nvim_configs

echo "setting up tmux..."
setup_tmux

echo "done. next steps:"
echo "  1. open nvim and wait for plugins to install"
echo "  2. run :SupermavenUseFree"
echo "  3. start tmux: tmux new -s main"
echo "  4. inside tmux: tmux source ~/.tmux.conf && press Ctrl+a then I"
