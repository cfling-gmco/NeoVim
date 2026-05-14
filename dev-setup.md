# Dev Environment Setup

## Stack
| Layer | Tool |
|---|---|
| Terminal | Ghostty (Linux/macOS) / Windows Terminal (WSL) |
| Multiplexer | tmux + tmux-resurrect |
| Editor | Neovim (LazyVim) |
| Completion | Supermaven (free tier) |
| Agent | `cursor` CLI |

---

## Automated Setup

```bash
bash setup.sh
```

Supports Arch/CachyOS, Ubuntu, and macOS. After running:
1. Open nvim and wait for plugins to install
2. Run `:SupermavenUseFree`
3. `tmux new -s main`
4. Inside tmux: `tmux source ~/.tmux.conf` then `Ctrl+Space I` to install plugins

---

## Dotfiles

These files should live in your dotfiles repo:

```
~/.config/nvim/lua/config/options.lua
~/.config/nvim/lua/plugins/supermaven.lua
~/.config/nvim/lua/plugins/snacks.lua
~/.config/nvim/lua/plugins/extras.lua
~/.tmux.conf
```

---

## Manual Reference

### Ghostty config
`~/.config/ghostty/config`:
```ini
theme = GruvboxDark
font-family = JetBrainsMono Nerd Font
font-size = 13
window-padding-x = 8
window-padding-y = 8
shell-integration = true
```
`ghostty +list-themes` for all options.

### Windows Terminal (WSL)
Install JetBrainsMono Nerd Font on Windows side from [nerdfonts.com](https://www.nerdfonts.com/font-downloads), set it in Windows Terminal profile settings.

### Remote hosts
SSH into host, run tmux + nvim there. Sync config via dotfiles repo — one clone gets full setup on any host.

---

## tmux Cheatsheet

Prefix = `Ctrl+Space`

| Action | Keys |
|---|---|
| Split vertical | `prefix + \|` |
| Split horizontal | `prefix + -` |
| Move between panes | `prefix + arrow keys` |
| Resize pane | `prefix + Ctrl + arrow keys` |
| Zoom pane (fullscreen toggle) | `prefix + z` |
| New window | `prefix + c` |
| Switch window | `prefix + number` |
| Save session | `prefix + Ctrl+s` |
| Restore session | `prefix + Ctrl+r` |

---

## Neovim Cheatsheet

Leader = `Space`

### Files & Navigation
| Action | Keys |
|---|---|
| Open project | `nvim .` in project root |
| Find file | `leader + f` |
| Toggle explorer | `leader + e` |
| Split vertical | `leader + \|` |
| Split horizontal | `leader + -` |
| Move between splits | `Ctrl + h/j/k/l` |
| Close split | `leader + wd` |
| Zoom split | `leader + wm` |

### Git
| Action | Keys |
|---|---|
| Open lazygit | `leader + g + g` |
| Toggle line change signs | `:Gitsigns toggle_signs` |
