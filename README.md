# Dotfiles

Personal development environment configuration managed with [Chezmoi](https://www.chezmoi.io/).

## Pre-requisites

Before running the install script, ensure your system has the required dependencies.

### macOS

```bash
# Install Xcode Command Line Tools (includes git, curl, etc.)
xcode-select --install
```

### Ubuntu / Debian

```bash
# Install build dependencies required by Homebrew
sudo apt update
sudo apt install -y build-essential curl file git
```

### Fedora / RHEL

```bash
# Install build dependencies
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y curl file git procps-ng
```

### Arch Linux

```bash
# Install base development tools
sudo pacman -S --needed base-devel curl file git
```

---

## Quick Install

Once pre-requisites are installed, run:

```bash
curl -fsSL https://raw.githubusercontent.com/dpcrespo/dotfiles/main/install.sh | bash
```

The script will:
1. Install Homebrew (if not present)
2. Install all packages from Brewfile
3. Apply dotfiles via Chezmoi
4. Set Fish as default shell
5. Install Node.js, Yarn, and LSPs via mise

### Manual Install

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Add Homebrew to PATH (Linux only)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 3. Install Chezmoi
brew install chezmoi

# 4. Apply dotfiles
chezmoi init --apply https://github.com/dpcrespo/dotfiles.git
```

---

## Post-Install

### Set up NPM token (optional)

If you use private NPM registries:

```bash
echo "your-npm-token" > ~/.npm_token
chmod 600 ~/.npm_token
```

### Restart terminal

```bash
exec fish
```

---

## What's Included

### Shell & Terminal
- **Fish** - Primary shell with vi keybindings
- **Kitty** - GPU-accelerated terminal
- **Zellij** - Terminal multiplexor with custom layouts
- **Starship** - Cross-shell prompt
- **Atuin** - Shell history search

### Editor
- **Neovim** - Configured for TypeScript/JavaScript development
  - LSP (ts_ls, eslint, lua_ls, stylelint)
  - Formatting (conform.nvim with ESLint/Prettier)
  - Treesitter syntax highlighting
  - FZF-Lua for grep, Snacks for file navigation

### CLI Tools
- **lazygit** / **lazydocker** - TUI for git and docker
- **yazi** - File manager
- **fzf** / **ripgrep** / **fd** - Search tools
- **zoxide** - Smart cd
- **mise** - Runtime version manager (Node.js, Yarn)

### Theme
- **Kanagawa** - Consistent across Neovim, Kitty, and Zellij

---

## Directory Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl          # User config (email, timezone)
├── .chezmoiexternal.toml       # External files (zjstatus.wasm)
├── .chezmoiscripts/            # Install scripts
├── Brewfile                    # Homebrew packages
├── install.sh                  # Bootstrap script
├── dot_gitconfig.tmpl          # Git config template
└── private_dot_config/
    ├── nvim/                   # Neovim config
    ├── fish/                   # Fish shell config
    ├── kitty/                  # Kitty terminal
    ├── zellij/                 # Zellij multiplexor
    ├── yazi/                   # File manager
    ├── atuin/                  # Shell history
    └── mise/                   # Runtime versions
```

---

## Templates

Some files are templated for OS/arch differences:

| File | Template Variables |
|------|-------------------|
| `fish/config.fish` | OS-specific paths (`/opt/nvim/bin` on Linux) |
| `kitty/kitty.conf` | Shell path (fish location varies by OS) |
| `zellij/layouts/work.kdl` | Timezone |
| `.gitconfig` | Email |

---

## Usage

### Update dotfiles
```bash
chezmoi update
```

### Edit a managed file
```bash
chezmoi edit ~/.config/nvim/init.lua
```

### Add a new file
```bash
chezmoi add ~/.config/newapp/config
```

### Re-apply (after editing source)
```bash
chezmoi apply
```

### Preview changes
```bash
chezmoi diff
```

---

## Fish Functions

| Function | Description |
|----------|-------------|
| `workon [project]` | Switch to project with zellij session |
| `zs` | Attach to existing zellij session |
| `zclean` | Kill all zellij sessions except current |
| `zkill <session>` | Kill specific session |
| `zls` | List zellij sessions |
| `t [filter]` | Run tests (vitest/jest) |
| `tw [filter]` | Run tests in watch mode |

---

## License

MIT
