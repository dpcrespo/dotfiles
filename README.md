# Dotfiles

Personal development environment configuration managed with [Chezmoi](https://www.chezmoi.io/).

## Quick Install (New Machine)

```bash
curl -fsSL https://raw.githubusercontent.com/dpcrespo/dotfiles/main/install.sh | bash
```

Or manually:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Chezmoi
brew install chezmoi

# Apply dotfiles
chezmoi init --apply https://github.com/dpcrespo/dotfiles.git
```

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

## Templates

Some files are templated for OS/arch differences:

| File | Template Variables |
|------|-------------------|
| `fish/config.fish` | OS-specific paths (`/opt/nvim/bin` on Linux) |
| `kitty/kitty.conf` | Shell path (fish location varies by OS) |
| `zellij/layouts/work.kdl` | Timezone |
| `.gitconfig` | Email |

## Secrets

**Never committed to the repo:**

- `~/.npm_token` - NPM authentication token

After install, create manually:
```bash
echo "your-npm-token" > ~/.npm_token
chmod 600 ~/.npm_token
```

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

## License

MIT
