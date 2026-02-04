# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration focused on TypeScript/JavaScript development with a minimal, modern setup using lazy.nvim for plugin management.

## Architecture

```
lua/
├── core/
│   ├── lazy.lua         # Plugin manager bootstrap (lazy.nvim)
│   └── lsp.lua          # LSP configuration and custom commands
├── config/
│   ├── options.lua      # Editor options (tabs=2, relative numbers, etc.)
│   ├── keymaps.lua      # Global keymaps (Oil, Harpoon, copy paths, FZF)
│   └── autocmds.lua     # Autocommands (LSP attach, document highlighting)
└── plugins/             # Individual plugin specs (auto-loaded by lazy.nvim)

lsp/                     # LSP server configurations (ts_ls, eslint, lua_ls, stylelint)
```

**Load order:** `config.options` → `core.lazy` → `core.lsp` → `config.keymaps` → `config.autocmds`

## Key Design Decisions

- **Leader key:** Space
- **Plugin management:** lazy.nvim with specs in `lua/plugins/`
- **Colorscheme:** Kanagawa with transparency
- **Primary picker:** Snacks.nvim for files, buffers, LSP navigation
- **Grep:** FZF-Lua (for dynamic exclusion support)
- **File explorer:** Oil.nvim and Snacks explorer
- **Formatting:** conform.nvim with smart ESLint detection (prefers project ESLint config, falls back to Prettier)

## LSP Setup

Language servers are enabled in `lua/core/lsp.lua`:
- `ts_ls` - TypeScript/JavaScript
- `eslint_lsp` - ESLint
- `lua_ls` - Lua
- `stylelint_lsp` - CSS/SCSS

Server configurations live in the `lsp/` directory.

**Custom LSP commands:**
- `:LspInfo` - Comprehensive LSP information
- `:LspStatus` - Quick status overview
- `:LspCapabilities` - Full capability list
- `:LspDiagnostics` - Diagnostic counts
- `:LspRestart` - Restart LSP clients

## Formatting

Configured in `lua/plugins/conform.lua`:
- **JS/TS:** ESLint (if config exists) or Prettier fallback
- **Lua:** Stylua
- **CSS/SCSS:** Stylelint
- **HTML/JSON/YAML/Markdown:** Prettier
- Format on save enabled (disable with `vim.g.disable_autoformat = true`)

## Key Keymaps

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart find files (Snacks) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (FZF) |
| `<leader>fb` | Buffers |
| `<leader>e` | File explorer |
| `-` | Open parent directory (Oil) |
| `<leader>lg` | Lazygit |
| `<leader>f` | Format buffer |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover |
| `<leader>la` | Code action |
| `<leader>lr` | Rename |
| `<leader>ha` | Harpoon add file |
| `<leader>hm` | Harpoon menu |
| `<leader>h1-4` | Harpoon jump to file |

## Dependencies

Check with `<leader>cd` in Neovim:
- git, node, npm
- ripgrep, fd
- stylua, prettier, eslint, stylelint
- lua-language-server, typescript-language-server
